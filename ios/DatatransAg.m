#import "DatatransAg.h"
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(DatatransAg, NSObject)

RCT_EXTERN_METHOD(startTransaction:(NSString *)mobileToken
                  options:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)rejecter)

@end
