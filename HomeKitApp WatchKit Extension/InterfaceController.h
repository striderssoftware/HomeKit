//
//  InterfaceController.h
//  HomeKitApp WatchKit Extension
//
//  Created by Dennis Lucero on 8/15/15.
//  Copyright (c) 2015 Dennis Lucero. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *message;

@end
