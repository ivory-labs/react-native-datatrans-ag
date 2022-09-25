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
        
        let transaction = Transaction(mobileToken: mobileToken)
        transaction.delegate = self
        transaction.options.testing = true
        transaction.options.useCertificatePinning = true
        
        context = Context(resolver: resolver, rejecter: rejecter)
        
        DispatchQueue.main.async {
            let rootVC = UIApplication.shared.keyWindow!.rootViewController!
            transaction.start(presentingController: rootVC)
        }
    }
    
}

extension DatatransAg: TransactionDelegate{
    
    func transactionDidFinish(_ transaction: Transaction, result: TransactionSuccess) {
        context.resolver(result)
    }
    
    func transactionDidFail(_ transaction: Transaction, error: TransactionError) {
        context.rejecter("-1", "Transaction Failed", error)
    }
    
}
