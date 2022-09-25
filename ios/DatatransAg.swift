import Foundation
import React

@objc(DatatransAg)
class DatatransAg: NSObject{
    
    @objc(startTransaction:options:resolver:rejecter:)
    func startTransaction(
        mobileToken: String,
        options: NSDictionary,
        resolver: RCTPromiseResolveBlock,
        rejecter: RCTPromiseRejectBlock
    ){
        let placeholder = NSDictionary(dictionary: [
            "name": "DatatransAg iOS Implementation",
            "status": "Work in progress"
        ])
        resolver(placeholder)
    }
    
}
