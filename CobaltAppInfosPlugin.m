//
//  CobaltAppInfosPlugin.m
//  Cobalt
//
//  Created by Kristal on 06/01/15.
//  Copyright (c) 2015 Kristal. All rights reserved.
//

#import "CobaltAppInfosPlugin.h"

@implementation CobaltAppInfosPlugin

- (void) onMessageFromCobaltController: (CobaltViewController *)viewController
                               andData: (NSDictionary *)data {
    [self onMessageWithCobaltController:viewController andData:data];
}

- (void) onMessageFromWebLayerWithCobaltController: (CobaltViewController *)viewController
                                           andData: (NSDictionary *)data {
    [self onMessageWithCobaltController:viewController andData:data];
}

- (void) onMessageWithCobaltController: (CobaltViewController *)viewController
                               andData: (NSDictionary *)data {
    NSString * callback = [data objectForKey:kJSCallback];
    NSString * action = [data objectForKey:kJSAction];
    
    if (action != nil && [action isEqualToString:@"getAppInfos"]) {
        NSDictionary * appInfos = [CobaltAppInfosPlugin getAppInfos];
        
        [viewController sendCallback: callback
                            withData: appInfos];
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
