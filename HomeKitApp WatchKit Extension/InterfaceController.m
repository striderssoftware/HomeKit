//
//  InterfaceController.m
//  HomeKitApp WatchKit Extension
//
//  Created by Dennis Lucero on 8/15/15.
//  Copyright (c) 2015 Dennis Lucero. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}
- (IBAction)I_Button
{
    static int iCount = 0;
    
    if ( iCount++ < 1 )
        [self.message setText:@"The button has been activated"];
    else
        [self.message setText:@"Do something else"];
    
    
    //send request to parent app
    NSMutableDictionary *userInfoSend = [[NSMutableDictionary alloc] init];
    [userInfoSend setObject:@"Twilight Zone" forKey:@"SendKey"];
    
    [WKInterfaceController openParentApplication:userInfoSend reply:^( NSDictionary *replyInfo, NSError *error ) {
        
        NSLog(@"InterfaceController: - Recieved reply from openParentApplication");
        
        // do something with the returned info
        NSLog(@"String from returned replyInfo: %@", [replyInfo objectForKey:@"ReturnKey"]);
    }];
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



