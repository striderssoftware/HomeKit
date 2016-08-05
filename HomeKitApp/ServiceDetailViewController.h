//
//  ServiceDetailViewController.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <HomeKit/HomeKit.h>

#import "ServiceProtocol.h"

@interface ServiceDetailViewController : UIViewController <UIAlertViewDelegate>

// strider
@property (strong, nonatomic) id <ServiceProtocol> pHKAService;
@property (strong, nonatomic) UIView* pLastViewLayout;

@end

