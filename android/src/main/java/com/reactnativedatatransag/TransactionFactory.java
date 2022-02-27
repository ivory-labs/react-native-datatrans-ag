package com.reactnativedatatransag;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import ch.datatrans.payment.api.Transaction;
import ch.datatrans.payment.paymentmethods.PaymentMethodType;
import ch.datatrans.payment.paymentmethods.SavedPaymentMethod;

public class TransactionFactory {
    public static final String PAYMENT_METHODS = "paymentMethods";
    public static final String TYPE = "type";
    public static final String ALIAS = "alias";
    public static final String IS_TESTING = "isTesting";
    public static final String SUPPRESS_CRITICAL_ERROR_DIALOG = "suppressCriticalErrorDialog";
    public static final String APP_CALLBACK_SCHEME = "appCallbackScheme";
    public static final String USE_CERTIFICATE_PINNING = "useCertificatePinning";

    public Transaction create(String mobileToken, ReadableMap map) {
        List<SavedPaymentMethod> savedPaymentMethods = getSavedPaymentMethods(map);
        boolean isTesting = getIsTesting(map);
        boolean suppressCriticalErrorDialog = getSuppressCriticalErrorDialog(map);
        boolean useCertificatePinning = getUseCertificatePinning(map);
        String appCallbackScheme = getAppCallbackScheme(map);

        Transaction transaction;
        if (savedPaymentMethods.size() == 0) {
            transaction = new Transaction(mobileToken);
        } else if (savedPaymentMethods.size() == 1) {
            transaction = new Transaction(mobileToken, savedPaymentMethods.get(0));
        } else {
            transaction = new Transaction(mobileToken, savedPaymentMethods);
        }
        transaction.getOptions().setTesting(isTesting);
        transaction.getOptions().setSuppressCriticalErrorDialog(suppressCriticalErrorDialog);
        transaction.getOptions().setUseCertificatePinning(useCertificatePinning);
        if (appCallbackScheme != null) {
            transaction.getOptions().setAppCallbackScheme(appCallbackScheme);
        }

        return transaction;
    }

    public boolean getIsTesting(ReadableMap map) {
        return map.getBoolean(IS_TESTING);
    }

    public boolean getSuppressCriticalErrorDialog(ReadableMap map) {
        return map.getBoolean(SUPPRESS_CRITICAL_ERROR_DIALOG);
    }

    public String getAppCallbackScheme(ReadableMap map) {
        return map.getString(APP_CALLBACK_SCHEME);
    }

    public boolean getUseCertificatePinning(ReadableMap map) {
        return map.getBoolean(USE_CERTIFICATE_PINNING);
    }

    public List<SavedPaymentMethod> getSavedPaymentMethods(ReadableMap map) {
        ReadableArray paymentMethods = map.getArray(PAYMENT_METHODS);
        if (paymentMethods == null) {
            return Collections.emptyList();
        }

        List<SavedPaymentMethod> savedPaymentMethods = new ArrayList<>();
        for (int i = 0; i < paymentMethods.size(); i++) {
            ReadableMap method = paymentMethods.getMap(i);
            if (method == null) {
                return savedPaymentMethods;
            }
            String type = method.getString(TYPE);
            String alias = method.getString(ALIAS);
            if (type == null || alias == null) {
                return savedPaymentMethods;
            }
            savedPaymentMethods.add(new SavedPaymentMethod(PaymentMethodType.valueOf(type), alias));
        }

        return savedPaymentMethods;
    }
}
