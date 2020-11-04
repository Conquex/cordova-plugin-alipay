/********* alipay.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <AlipaySDK/AlipaySDK.h>

@interface alipay : CDVPlugin {
    // Member variables go here.
    NSString *app_id;
    NSString *callbackId;
}

- (void)payment:(CDVInvokedUrlCommand*)command;
@end

@implementation alipay

#pragma mark "API"
- (void)pluginInitialize {
    CDVViewController *viewController = (CDVViewController *)self.viewController;
    app_id = @"kodypayapp";
}

- (void)payment:(CDVInvokedUrlCommand*)command
{
    callbackId = command.callbackId;
    NSString* orderString = [command.arguments objectAtIndex:0];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:app_id callback:^(NSDictionary *resultDic) {
        CDVPluginResult* pluginResult;
        
        if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        }
        
    }];
}

- (void)handleOpenURL:(NSNotification *)notification {
    NSURL* url = [notification object];
    
    if ([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString: app_id])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            CDVPluginResult* pluginResult;
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqual: @"9000"]) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDic];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:resultDic];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
            }
        }];
    }
}

@end
