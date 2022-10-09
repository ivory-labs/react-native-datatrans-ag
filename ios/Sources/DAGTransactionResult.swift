import Foundation

/**
 End transaction result reported by
 DataTrans iOS SDK
 */
struct TransactionResult {
    private let transactionId: String?
    private let state: DAGConstants.Status

    init(_ transactionId: String?, _ state: DAGConstants.Status) {
        self.transactionId = transactionId
        self.state = state
    }

    public static func success(transactionId: String) -> TransactionResult {
        return TransactionResult(transactionId, .SUCCESS)
    }

    public static func canceled() -> TransactionResult {
        return TransactionResult(nil, .CANCELED);
    }

    public func toDictionary() -> NSDictionary{
        return NSDictionary(dictionary: [
            "transactionId": transactionId ?? nil, // ignore Xcode Warning
            "state": state.name()
        ])
    }
}
