//
//  SettingsViewController.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <HomeKit/HomeKit.h>

#import "ServiceProtocol.h"


#define GO_TO_PRIMARY_HOME @"GO_TO_PRIMARY_HOME"
#define GO_TO_ACCESSORY_DETAIL @"GO_TO_ACCESSORY_DETAIL"

@interface SettingsViewController : UIViewController <UIAlertViewDelegate>

// strider
@property (strong, nonatomic) UISwitch* pSwitch;
@property (strong, nonatomic) UISwitch* pSwitch2;
@property (strong, nonatomic) UISwitch* pSwitch3;

@end
