import Foundation
import React
import Datatrans

final class DAGTransactionFactory{
    
    enum FactoryError: Error{
        // case nullError(msg: String)
        case parsingError(msg: String)
        
        var localizedDescription: String{
            switch(self){
            // case .nullError(msg: let msg): return msg
            case .parsingError(msg: let msg): return msg
            }
        }
    }
    
    private typealias K = DAGConstants.Keys
    
    init(){}
    
    func create(mobileToken: String, options: NSDictionary) throws -> Transaction{
        let isTesting = try getBool(map: options, key: K.IS_TESTING)
        let suppressCriticalErrorDialog = try getBool(map: options, key: K.SUPPRESS_CRITICAL_ERROR_DIALOG)
        let useCertificatePinning = try getBool(map: options, key: K.USE_CERTIFICATE_PINNING)
        let appCallbackScheme = try getString(map: options, key: K.APP_CALLBACK_SCHEME)
        
        let transaction: Transaction
        
        // todo: handle saved payment methods
        
        // debug
        print("isTesting =", isTesting)
        print("suppr. =", suppressCriticalErrorDialog)
        print("certPin =", useCertificatePinning)
        print("scheme =", appCallbackScheme)
        
        transaction = Transaction(mobileToken: mobileToken)
        
        transaction.options.testing = isTesting
        transaction.options.useCertificatePinning = useCertificatePinning
        transaction.options.suppressCriticalErrorDialog = suppressCriticalErrorDialog
        transaction.options.appCallbackScheme = appCallbackScheme
        
        return transaction
    }
    
}

// MARK: Data Extraction

extension DAGTransactionFactory{
    
    private func getArray(map: NSDictionary, key: String) throws -> NSArray{
        guard let obj = map.value(forKey: key) else{
            // throw FactoryError.nullError(msg: "\(key) array was null")
            return NSArray()
        }
        
        guard let array = obj as? NSArray else {
            throw FactoryError.parsingError(msg: "\(key) might not be an array")
        }
        
        return array
    }
    
    private func getBool(map: NSDictionary, key: String) throws -> Bool{
        guard let obj = map.value(forKey: key), !isNull(value: obj) else{
            // throw FactoryError.nullError(msg: "\(key) bool was null")
            return false
        }
        
        guard let bool = obj as? Bool else {
            throw FactoryError.parsingError(msg: "\(key) might not be a bool")
        }
        
        return bool
    }
    
    private func getString(map: NSDictionary, key: String) throws -> String?{
        guard let obj = map.value(forKey: key), !isNull(value: obj) else{
            // throw FactoryError.nullError(msg: "\(key) string was null")
            return nil
        }
        
        guard let str = obj as? String else {
            throw FactoryError.parsingError(msg: "\(key) might not be a string")
        }
        
        return str
    }
    
    private func isNull(value: Any?) -> Bool{
        return value is NSNull
    }
}
