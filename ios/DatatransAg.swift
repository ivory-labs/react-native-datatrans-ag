import Foundation
import React
import Datatrans

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
        // TODO
        // 1. Proper implementation of sending response by serialization
        // 2. Extracting options from map
        // 3. Organize stuff
        
        // https://docs.datatrans.ch/docs/mobile-sdk#ios-integration
        // Demo code
        
//        let transaction = Transaction(mobileToken: mobileToken)
//        transaction.delegate = self
//        transaction.options.testing = true
//        transaction.options.useCertificatePinning = true
        
        do{
            let transaction = try DAGTransactionFactory().create(
                mobileToken: mobileToken,
                options: options)
            
            context = Context(resolver: resolver, rejecter: rejecter)
            
            DispatchQueue.main.async {
                let rootVC = UIApplication.shared.keyWindow!.rootViewController!
                transaction.start(presentingController: rootVC)
            }
        }
        catch let error as DAGTransactionFactory.FactoryError{
            rejecter(
                DAGConstants.Status.FAILED,
                DAGConstants.Errors.PAYPARAM,
                error)
        }
        catch{
            rejecter(
                DAGConstants.Status.FAILED,
                DAGConstants.Errors.UNKNOWN,
                error)
        }
    }
    
}

extension DatatransAg: TransactionDelegate{
    
    func transactionDidFinish(_ transaction: Transaction, result: TransactionSuccess) {
        context.resolver(result)
    }
    
    func transactionDidFail(_ transaction: Transaction, error: TransactionError) {
        context.rejecter(
            DAGConstants.Status.FAILED,
            DAGConstants.Errors.TRANSACTION,
            error)
    }
    
}
