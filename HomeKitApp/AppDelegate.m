//
//  AppDelegate.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RoomViewController.h"
#import "SettingsViewController.h"

@interface AppDelegate ()

@end


@implementation AppDelegate
            
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
	
    UITableViewController* pRootViewController;
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* szGoToPrimaryHome = [defaults valueForKey:GO_TO_PRIMARY_HOME];
    
    if ( szGoToPrimaryHome.boolValue )
        pRootViewController = [[RoomViewController alloc] init];
    else
        pRootViewController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    
    //SET UP NAV CONTROLER
    UINavigationController* PNavigationController = [[UINavigationController alloc]  initWithRootViewController:pRootViewController];
    self.myNavController = PNavigationController;
    
    // TOOLBAR
    PNavigationController.toolbarHidden = false;
    [[PNavigationController toolbar]setBarStyle:UIBarStyleDefault];
    
	//TODO - HMHomeDelegate
	//have a HMHomeDelegate whos lifetime is that of the app. independant of any controller or view
	//For all these my HMHomeDelegate class impl will make the appropriate segue.
    //TODONE ? These are handeld by alerts and segues in the HomeViewController leave them there?
	
	//TODO - Have persistant setting so app will start at un-assigned (new) accessories page.
	
	self.window.rootViewController = PNavigationController;
	[self.window makeKeyAndVisible];
	
	return YES;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
{
    
    __block UIBackgroundTaskIdentifier watchKitHandler;

    
    watchKitHandler = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"backgroundTask"
                                                                   expirationHandler:^{
                                                                       watchKitHandler = UIBackgroundTaskInvalid;
                                                                   }];
    
    
    AppDelegate *tmpDelegate = (AppDelegate *)[application delegate];
    [tmpDelegate handleWatchKitRequest];
    
     NSLog(@"String received from WathKit Extension: %@", [userInfo objectForKey:@"SendKey"]);
    
    
    
    NSMutableDictionary *userInfoReturn = [[NSMutableDictionary alloc] init];
    //[userInfoReturn setObject:@"Here is some information from AppDelegate" forKey:@"ReturnKey"];
    
    [userInfoReturn setObject:[userInfo objectForKey:@"SendKey"] forKey:@"ReturnKey"];
    
    
    reply(userInfoReturn);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC * 1), dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] endBackgroundTask:watchKitHandler];
    });
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)handleWatchKitRequest
{
    UITableViewController* pRoomViewController;
    pRoomViewController = [[RoomViewController alloc] init];

    
    
    //SettingsViewController* pSettingsViewController = [[SettingsViewController alloc] init];
    [self.myNavController pushViewController:pRoomViewController animated:YES];
  
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
