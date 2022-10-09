import Foundation
import React
import Datatrans

/**
 Creates DataTrans Transaction objects
 */
final class DAGTransactionFactory{
    
    enum FactoryError: Error{
        case parsingError(msg: String)
        
        var localizedDescription: String{
            switch(self){
            case .parsingError(msg: let msg): return msg
            }
        }
    }
    
    private typealias K = DAGConstants.Keys
    
    init(){}
    
    func create(mobileToken: String, options: NSDictionary) throws -> Transaction{
        let methods = try getSavedPaymentMethods(map: options)
        let isTesting = try getBool(map: options, key: K.IS_TESTING)
        let suppressCriticalErrorDialog = try getBool(map: options, key: K.SUPPRESS_CRITICAL_ERROR_DIALOG)
        let useCertificatePinning = try getBool(map: options, key: K.USE_CERTIFICATE_PINNING)
        let appCallbackScheme = try getString(map: options, key: K.APP_CALLBACK_SCHEME)
        
        let transaction: Transaction
        
        #if DEBUG
        print("[DEBUG] DataTrans iOS Transaction Factory")
        print(": isTesting =", isTesting)
        print(": suppr. Err. Dialog =", suppressCriticalErrorDialog)
        print(": certPin =", useCertificatePinning)
        print(": scheme =", appCallbackScheme ?? "scheme was null")
        print(": saved method counts =", methods.count)
        #endif
        
        switch(methods.count){
        case 0:     transaction = Transaction(mobileToken: mobileToken)
        case 1:     transaction = Transaction(mobileToken: mobileToken, savedPaymentMethod: methods[0])
        default:    transaction = Transaction(mobileToken: mobileToken, savedPaymentMethods: methods)
        }
        
        transaction.options.testing = isTesting
        transaction.options.useCertificatePinning = useCertificatePinning
        transaction.options.suppressCriticalErrorDialog = suppressCriticalErrorDialog
        transaction.options.appCallbackScheme = appCallbackScheme
        
        return transaction
    }
    
    private func getSavedPaymentMethods(map: NSDictionary) throws -> [SavedPaymentMethod]{
        let key = K.PAYMENT_METHODS
        var methods: [SavedPaymentMethod] = []
        
        let methodsInMap = try getArray(map: map, key: key)
        let methodsInMapCount = methodsInMap.count
        if (methodsInMapCount > 0){
            for i in 0..<methodsInMapCount{
                guard let item = methodsInMap.object(at: i) as? NSDictionary, !isNull(value: item) else {
                    break
                }
                
                guard let type = try getInteger(map: item, key: K.TYPE),
                      let alias = try getString(map: item, key: K.ALIAS) else {
                    break
                }
                
                let methodType = PaymentMethodType(rawValue: type)!
                let method = SavedPaymentMethod(type: methodType, alias: alias)
                methods.append(method)
            }
        }
        
        return methods
    }
    
}

// MARK: Data Extraction

extension DAGTransactionFactory{
    
    private func getArray(map: NSDictionary, key: String) throws -> NSArray{
        guard let obj = map.value(forKey: key) else{
            return NSArray()
        }
        
        guard let array = obj as? NSArray else {
            throw FactoryError.parsingError(msg: "\(key) might not be an array")
        }
        
        return array
    }
    
    private func getBool(map: NSDictionary, key: String) throws -> Bool{
        guard let obj = map.value(forKey: key), !isNull(value: obj) else{
            return false
        }
        
        guard let bool = obj as? Bool else {
            throw FactoryError.parsingError(msg: "\(key) might not be a bool")
        }
        
        return bool
    }
    
    private func getString(map: NSDictionary, key: String) throws -> String?{
        guard let obj = map.value(forKey: key), !isNull(value: obj) else{
            return nil
        }
        
        guard let str = obj as? String else {
            throw FactoryError.parsingError(msg: "\(key) might not be a string")
        }
        
        return str
    }
    
    private func getInteger(map: NSDictionary, key: String) throws -> Int?{
        guard let obj = map.value(forKey: key), !isNull(value: obj) else{
            return nil
        }
        
        guard let str = obj as? Int else {
            throw FactoryError.parsingError(msg: "\(key) might not be an integer")
        }
        
        return str
    }
    
    private func isNull(value: Any?) -> Bool{
        return value is NSNull
    }
}
