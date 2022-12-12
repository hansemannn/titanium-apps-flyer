/**
 * Titanium AppsFlyer SDK
 *
 * Created by Hans Knöchel
 * Copyright (c) 2022 Hans Knöchel. All rights reserved.
 */

#import "TiModule.h"

@interface TiAppsflyerModule : TiModule <UIApplicationDelegate> {

}

- (void)initialize:(id)args;

- (void)start:(id)unused;

- (void)requestTrackingAuthorization:(id)callback;

- (NSNumber *)trackingAuthorizationStatus;

- (void)fetchAdvertisingIdentifier:(id)callback;

- (void)logEvent:(id)args;

@end
