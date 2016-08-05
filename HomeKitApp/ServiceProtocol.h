//
//  ServiceProtocol.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@protocol ServiceProtocol <NSObject>

- (UIView*)SetViewControls;
- (void)setPHMService:(HMService*) pService;
- (NSString*)GetName;

@end
