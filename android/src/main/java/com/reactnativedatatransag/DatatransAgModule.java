package com.reactnativedatatransag;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.module.annotations.ReactModule;

import java.util.Objects;

import ch.datatrans.payment.api.Transaction;
import ch.datatrans.payment.api.TransactionListener;
import ch.datatrans.payment.api.TransactionRegistry;
import ch.datatrans.payment.api.TransactionSuccess;
import ch.datatrans.payment.exception.TransactionException;

@ReactModule(name = DatatransAgModule.NAME)
public class DatatransAgModule extends ReactContextBaseJavaModule {
    public static final String NAME = "DatatransAg";
    private final static String TAG = DatatransAgModule.class.getName();
    private final TransactionFactory transactionFactory;

    public DatatransAgModule(ReactApplicationContext reactContext) {
        super(reactContext);
        transactionFactory = new TransactionFactory();
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    @ReactMethod
    public void startTransaction(String mobileToken, ReadableMap options, Promise promise) {
        Transaction transaction = transactionFactory.create(mobileToken, options);
        transaction.setListener(new TransactionListener() {
            @Override
            public void onTransactionSuccess(TransactionSuccess transactionSuccess) {
                promise.resolve(TransactionResult.success(transactionSuccess.getTransactionId()).writableMap());
            }

            @Override
            public void onTransactionError(TransactionException e) {
                promise.reject(e);
            }

            @Override
            public void onTransactionCancel() {
                promise.resolve(TransactionResult.canceled().writableMap());
            }
        });
        TransactionRegistry.INSTANCE.startTransaction(
                Objects.requireNonNull(getReactApplicationContext().getCurrentActivity()), transaction);
    }
}
