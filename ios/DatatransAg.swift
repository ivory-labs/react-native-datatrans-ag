import Foundation
import React
import Datatrans

/**
 Main DataTrans iOS Implementation
 */
@objc(DatatransAg)
class DatatransAg: NSObject{
    
    private let logger = DAGLogger(tag: "Module")
    
    private struct Context{
        var resolver: RCTPromiseResolveBlock
        var rejecter: RCTPromiseRejectBlock
    }
    
    private var context: Context!
    
    @objc(startTransaction:options:resolver:rejecter:)
    func startTransaction(
        mobileToken: String,
        options: NSDictionary,
        resolver: @escaping RCTPromiseResolveBlock,
        rejecter: @escaping RCTPromiseRejectBlock
    ){
        
        // INFO:
        // https://docs.datatrans.ch/docs/mobile-sdk#ios-integration
        
        do{
            let transaction = try DAGTransactionFactory().create(
                mobileToken: mobileToken,
                options: options)
            
            transaction.delegate = self
            context = Context(resolver: resolver, rejecter: rejecter)
            
            DispatchQueue.main.async {
                let rootVC = UIApplication.shared.keyWindow!.rootViewController!
                transaction.start(presentingController: rootVC)
            }
        }
        catch{
            if let validationError = error as? DAGTransactionFactory.FactoryError{
                logger.print("Transaction Factory Error")
                logger.print("error = \(validationError.localizedDescription)")
            }
            else{
                logger.print("Transaction Generation Error")
                logger.print("error description = \(error.localizedDescription)")
            }
            rejecter(
                DAGConstants.Codes.ERROR,
                error.localizedDescription,
                nil)
        }
    }
    
}

extension DatatransAg: TransactionDelegate{
    
    func transactionDidFinish(_ transaction: Transaction, result: TransactionSuccess) {
        logger.print("Transaction Finished")
        logger.print("method = \(result.paymentMethodType)")
        logger.print("savedMethod = \(String(describing: result.savedPaymentMethod))")
        logger.print("transactionId = \(result.transactionId)")
        context.resolver(TransactionResult.success(transactionId: result.transactionId).toDictionary())
    }
    
    func transactionDidFail(_ transaction: Transaction, error: TransactionError) {
        logger.print("Transaction Failed")
        logger.print("error description = \(error.localizedDescription)")
        logger.print("error failure reason = \(error.localizedFailureReason ?? "null")")
        logger.print("error recovery = \(error.localizedRecoverySuggestion ?? "null")")
        context.rejecter(
            DAGConstants.Codes.ERROR,
            error.localizedDescription,
            nil)
    }
    
    func transactionDidCancel(_ transaction: Transaction) {
        logger.print("Transaction Canceled")
        context.resolver(TransactionResult.canceled().toDictionary())
    }
    
}
