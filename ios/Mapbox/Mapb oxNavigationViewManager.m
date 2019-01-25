//
//  NavigationViewManager.m
//  SafeRideTests
//
//  Created by Clement on 1/22/19.
//

#import <UIKit/UIKit.h>
#import <React/RCTUIManager.h>
#import "RNMapboxNavigation-Swift.h"

@interface MapboxNavigationViewManager : RCTViewManager
@end

@implementation MapboxNavigationViewManager

RCT_EXPORT_MODULE()

- (UIView *)view {
  return [MapboxNavigationView new];
}

RCT_EXPORT_VIEW_PROPERTY(origin, NSDictionary *)
RCT_EXPORT_VIEW_PROPERTY(destination, NSDictionary *)

@end
