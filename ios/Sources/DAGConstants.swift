/**
 Constants for Strings, Codes, etc.
 */
enum DAGConstants{
    
    enum Codes{
        static let ERROR = "datatrans_error"
    }
    
    enum Status{
        case SUCCESS
        case CANCELED
        
        func name() -> String{
            switch(self){
            case .SUCCESS: return "SUCCESS"
            case .CANCELED: return "CANCELED"
            }
        }
    }
    
    enum Errors{
        static let TRANSACTION = "Transaction Error"
        static let PAYPARAM = "Payment Parameter Error"
        static let UNKNOWN = "Unknown Error"
    }
    
    enum Keys{
        static let PAYMENT_METHODS = "paymentMethods"
        static let TYPE = "type"
        static let ALIAS = "alias"
        static let IS_TESTING = "isTesting"
        static let SUPPRESS_CRITICAL_ERROR_DIALOG = "suppressCriticalErrorDialog"
        static let APP_CALLBACK_SCHEME = "appCallbackScheme"
        static let USE_CERTIFICATE_PINNING = "useCertificatePinning"
    }
}
