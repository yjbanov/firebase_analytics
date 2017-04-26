// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FirebaseAnalyticsPlugin.h"

#import "Firebase/Firebase.h"

@implementation FirebaseAnalyticsPlugin {
}

- (instancetype)initWithController:(FlutterViewController *)controller {
  self = [super init];
  if (self) {
    if (![FIRApp defaultApp]) {
      [FIRApp configure];
    }
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"firebase_analytics"
                                     binaryMessenger:controller];
    [channel setMethodCallHandler:^(FlutterMethodCall *call,
                                    FlutterResult result) {
      if ([@"logEvent" isEqualToString:call.method]) {
        NSString *eventName = call.arguments[@"name"];
        id parameterMap = call.arguments[@"parameters"];

        if (parameterMap != [NSNull null]) {
          [FIRAnalytics logEventWithName:eventName
                        parameters:parameterMap];
        } else {
          [FIRAnalytics logEventWithName:eventName
                        parameters:nil];
        }

        result(nil);
      } else if ([@"setUserId" isEqualToString:call.method]) {
        NSString *userId = call.arguments;
        [FIRAnalytics setUserID:userId];
        result(nil);
      } else if ([@"setCurrentScreen" isEqualToString:call.method]) {
        NSString *screenName = call.arguments[@"screenName"];
        NSString *screenClassOverride = call.arguments[@"screenClassOverride"];
        [FIRAnalytics setScreenName:screenName screenClass:screenClassOverride];
        result(nil);
      } else if ([@"setUserProperty" isEqualToString:call.method]) {
        NSString *name = call.arguments[@"name"];
        NSString *value = call.arguments[@"value"];
        [FIRAnalytics setUserPropertyString:value forName:name];
        result(nil);
      } else {
        NSString *message = [NSString stringWithFormat:@"Method not implemented: %@", call.method];
        result([FlutterError errorWithCode:message
                             message:message
                             details:message]);
      }
    }];
  }
  return self;
}

@end
