//
//  CobaltAppInfosPlugin.m
//  Cobalt
//
//  Created by Kristal on 06/01/15.
//  Copyright (c) 2015 Kristal. All rights reserved.
//

#import "CobaltAppInfosPlugin.h"

#import <Cobalt/Cobalt.h>
#import <Cobalt/PubSub.h>

@implementation CobaltAppInfosPlugin

- (void)onMessageFromWebView:(WebViewType)webView
          inCobaltController:(nonnull CobaltViewController *)viewController
                  withAction:(nonnull NSString *)action
                        data:(nullable NSDictionary *)data
          andCallbackChannel:(nullable NSString *)callbackChannel
{
    if ([action isEqualToString:@"getAppInfos"]
        && callbackChannel != nil)
    {
        NSDictionary *appInfos = [CobaltAppInfosPlugin getAppInfos];
        [[PubSub sharedInstance] publishMessage:appInfos
                                      toChannel:JSEventOnAppStarted];
    }
}

+ (NSDictionary *) getAppInfos {
    NSBundle * mainBundle = [NSBundle mainBundle];
    if (mainBundle == nil) return @{};
    
    NSDictionary * infos = [[NSBundle mainBundle] infoDictionary];
    NSString * version = [infos objectForKey:@"CFBundleShortVersionString"];
    NSString * build = [infos objectForKey:@"CFBundleVersion"];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *languageCode = [currentLocale objectForKey:NSLocaleLanguageCode];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSMutableString *lang = [NSMutableString stringWithString:languageCode];
    if (countryCode != nil && countryCode.length != 0) [lang appendFormat:@"-%@", countryCode];
    
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return @{@"versionName": version,
             @"versionCode": build,
             @"lang": lang,
             @"platform": @"ios",
             @"deviceId": deviceId};
}

@end
