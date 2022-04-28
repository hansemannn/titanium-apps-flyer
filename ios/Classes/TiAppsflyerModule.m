/**
 * Titanium AppsFlyer SDK
 *
 * Created by Hans Knöchel
 * Copyright (c) 2022 Hans Knöchel. All rights reserved.
 */

#import "TiAppsflyerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import <AppsFlyerLib/AppsFlyerLib.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@implementation TiAppsflyerModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"ac995713-e6a6-4463-91cc-5c6b4ffdcb02";
}

- (NSString *)moduleId
{
  return @"ti.appsflyer";
}

#pragma Public APIs

- (void)initialize:(id)args
{
  ENSURE_SINGLE_ARG(args, NSDictionary);

  NSString *devKey = [TiUtils stringValue:args[@"devKey"]];
  NSString *appID = [TiUtils stringValue:args[@"appID"]];
  NSInteger authorizationTimeout = [TiUtils intValue:args[@"authorizationTimeout"] def:-1];
  BOOL debugMode = [TiUtils boolValue:args[@"debug"] def:NO];

  [[AppsFlyerLib shared] setAppsFlyerDevKey:devKey];
  [[AppsFlyerLib shared] setAppleAppID:appID];
  [[AppsFlyerLib shared] setIsDebug:debugMode];

  if (authorizationTimeout != -1) {
    [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:authorizationTimeout];
  }
}

- (void)start:(id)unused
{
  [[AppsFlyerLib shared] start];
}

- (void)requestTrackingAuthorization:(id)callback
{
  ENSURE_SINGLE_ARG(callback, KrollCallback);

  if (@available(iOS 14, *)) {
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
      [callback call:@[@{ @"status": @(status) }] thisObject:self];
    }];
  } else {
    NSLog(@"[ERROR] Do not call \"requestTrackingAuthorization\" on devices < iOS 14");
  }
}

- (NSNumber *)trackingAuthorizationStatus
{
  if (@available(iOS 14, *)) {
    return @(ATTrackingManager.trackingAuthorizationStatus);
  } else {
    return @(-1);
  }
}

- (void)fetchAdvertisingIdentifier:(id)callback
{
  ENSURE_SINGLE_ARG(callback, KrollCallback);

  [callback call:@[@{
    @"idfa": [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
  }] thisObject:self];
}

- (void)logEvent:(id)args
{
  NSString *eventName = [TiUtils stringValue:args[0]];
  NSDictionary *values = args[1];

  [[AppsFlyerLib shared] logEvent:eventName withValues:values];
}

@end
