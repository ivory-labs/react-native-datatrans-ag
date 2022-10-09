import Foundation
import React
import Datatrans

/**
 Main DataTrans iOS Implementation
 */
@objc(DatatransAg)
class DatatransAg: NSObject{
    
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
            rejecter(
                DAGConstants.Codes.ERROR,
                error.localizedDescription,
                nil)
        }
    }
    
}

extension DatatransAg: TransactionDelegate{
    
    func transactionDidFinish(_ transaction: Transaction, result: TransactionSuccess) {
        context.resolver(TransactionResult.success(transactionId: result.transactionId).toDictionary())
    }
    
    func transactionDidFail(_ transaction: Transaction, error: TransactionError) {
        context.rejecter(
            DAGConstants.Codes.ERROR,
            error.localizedDescription,
            nil)
    }
    
    func transactionDidCancel(_ transaction: Transaction) {
        context.resolver(TransactionResult.canceled().toDictionary())
    }
    
}
