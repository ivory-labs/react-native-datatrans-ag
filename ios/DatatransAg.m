#import "DatatransAg.h"
#import <React/RCTBridgeModule.h>

//@implementation DatatransAg
//
//RCT_EXPORT_MODULE()
//
//// Example method
//// See // https://reactnative.dev/docs/native-modules-ios
//RCT_REMAP_METHOD(multiply,
//                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
//                 withResolver:(RCTPromiseResolveBlock)resolve
//                 withRejecter:(RCTPromiseRejectBlock)reject)
//{
//  NSNumber *result = @([a floatValue] * [b floatValue]);
//
//  resolve(result);
//}
//
//// String, Map, Promise
//
//
//
//@end

@interface RCT_EXTERN_MODULE(DatatransAg, NSObject)

RCT_EXTERN_METHOD(startTransaction:(NSString *)mobileToken
                  options:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)rejecter)

@end
