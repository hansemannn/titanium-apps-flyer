/**
 * Titanium AppsFlyer SDK
 *
 * Created by Hans Knöchel
 * Copyright (c) 2022-present Hans Knöchel. All rights reserved.
 */

#import "TiAppsflyerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiApp.h"
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

- (void)_configure
{
  [super _configure];
  [[TiApp app] registerApplicationDelegate:self];
}

-(void)_destroy
{
  [super _destroy];
  [[TiApp app] unregisterApplicationDelegate:self];
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
  [[AppsFlyerLib shared] setUseUninstallSandbox:debugMode];

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

  [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
    [callback call:@[@{ @"status": @(status) }] thisObject:self];
  }];
}

- (NSNumber *)trackingAuthorizationStatus
{
  return @(ATTrackingManager.trackingAuthorizationStatus);
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  [[AppsFlyerLib shared] registerUninstall:deviceToken];
}

@end
