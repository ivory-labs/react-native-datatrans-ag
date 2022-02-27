package com.reactnativedatatransag;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

public class TransactionResult {
    private final String transactionId;
    private final TransactionState state;

    private TransactionResult(String transactionId, TransactionState state) {
        this.transactionId = transactionId;
        this.state = state;
    }

    public static TransactionResult success(String transactionId) {
        return new TransactionResult(transactionId, TransactionState.SUCCESS);
    }

    public static TransactionResult canceled() {
        return new TransactionResult(null, TransactionState.CANCELED);
    }

    public String getTransactionId() {
        return transactionId;
    }

    public TransactionState getState() {
        return state;
    }

    public WritableMap writableMap() {
        WritableMap map = new WritableNativeMap();
        map.putString("transactionId", transactionId);
        map.putString("state", state.name());
        return map;
    }
}
