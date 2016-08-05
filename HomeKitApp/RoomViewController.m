//
//  RoomViewController.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomViewController.h"
#import "RoomAccessoryViewController.h"
#import "AccessoryViewController.h"
#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "ZoneViewController.h"
#import "ZoneDetailViewController.h"

@interface RoomViewController ()

@end

@implementation RoomViewController

@synthesize pHMHome;
@synthesize pRoomsList;
@synthesize pHMHomeManager;
@synthesize pHMZoneDetialViewController;
@synthesize pHomesList;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    //TODO do not need these checks - you can send messages to nil, but not having them bothers me.
    if ( self.pHMHome != nil )
        self.title = [NSString stringWithFormat:@"%@ Rooms", [self.pHMHome name]];

    //This page should alway go back to homes page.
    UIBarButtonItem *alwaysBackToHomes = [[UIBarButtonItem alloc] initWithTitle:@"Homes" style:UIBarButtonItemStylePlain target:self action:@selector(alwaysBackToHomes)];
    self.navigationItem.leftBarButtonItem = alwaysBackToHomes;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // TOOLBAR
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Accessories" style:UIBarButtonItemStyleDone target:self action:@selector(assignAccessory)];
    //UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"        Settings        " style:UIBarButtonItemStyleDone target:self action:@selector(segueToSettingsPage)];

    UIBarButtonItem *spacer=[[UIBarButtonItem alloc]initWithTitle:@"Zones" style:UIBarButtonItemStyleDone target:self action:@selector(segueToZonesPage)];
    [self setToolbarItems:[[NSArray alloc] initWithObjects:button1,button2,spacer,nil]];
    
    // INITIALIZE THE ROOM LIST
    if ( self.pHMHome != nil )
        self.pRoomsList = [[NSMutableArray alloc] initWithArray:self.pHMHome.rooms copyItems:NO];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-(void) segueToSettingsPage
{
    SettingsViewController* pSettingsViewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:pSettingsViewController animated:YES];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-(void) segueToZonesPage
{
    ZoneViewController* pZoneViewController = [[ZoneViewController alloc] init];
    pZoneViewController.pHMHome = pHMHome;
    [self.navigationController pushViewController:pZoneViewController animated:YES];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) homeManagerDidUpdateHomes:(HMHomeManager *)manager
{
    
    self.pHomesList = [[NSMutableArray alloc] initWithArray:[self.pHMHomeManager homes] copyItems:NO];
    
    NSLog(@"HomeList count is:%lu", (unsigned long)self.pHomesList.count);
    
    for (int i = 0; i < self.pHomesList.count; i++)
    {
        HMHome* pHMHomeTemp = [self.pHomesList objectAtIndex:i];
        NSLog(@" home name from manager is: %@", pHMHomeTemp.name);
        if ( [pHMHomeTemp isPrimary])
        {
            NSLog(@"primary home");
            self.pHMHome = pHMHomeTemp;
            //SET THE ROOMS LIST
            self.pRoomsList = [[NSMutableArray alloc] initWithArray:self.pHMHome.rooms copyItems:NO];
        }
    }
    
    NSLog(@"HomeList count is:%lu", (unsigned long)self.pHomesList.count);
    
    [self.tableView reloadData];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager
{
#ifdef strider
    NSArray* homesList = [manager homes];
    
    NSLog(@"HomeList count is:%lu", (unsigned long)homesList.count);
    
    for (int i = 0; i < homesList.count; i++)
    {
        HMHome* pHMHome = [homesList objectAtIndex:i];
        NSLog(@" home name is: %@", pHMHome.name);
        
        if ( ![pHMHome isPrimary])
        {
            NSLog(@"no primary home");
        }
    }
#endif
    
    self.pHMHome = [manager primaryHome];
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)assignAccessory
{
    NSLog(@"RoomViewController:AssignAccessory");

    AccessoryViewController* pAccessoryViewController = [[AccessoryViewController alloc] init];
    pAccessoryViewController.pHMHome = pHMHome;
    pAccessoryViewController.pHMRoom = nil;
    
    [self.navigationController pushViewController:pAccessoryViewController animated:YES];
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)alwaysBackToHomes
{
    HomeViewController* pHomeViewController = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:pHomeViewController animated:YES];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		HMRoom* pHMRoom = [self.pRoomsList objectAtIndex:indexPath.row];
		NSLog(@" Room name for table cell is:%@", [pHMRoom name]);
		
		[pHMHome removeRoom:pHMRoom completionHandler:^(NSError* error){
			if ( error != nil )
            {
                NSLog(@"Error Encountered");
                NSLog(@"error: %@", error);
            }
            else
            {
                NSLog(@"Removed Room, name is:%@", [pHMRoom name]);
				
				[self.pRoomsList removeObjectAtIndex:indexPath.row];
				
				[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
    else if ( UITableViewCellEditingStyleInsert )
    {
        [self addRoom];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMRoom* pHMRoom = [self.pRoomsList objectAtIndex:indexPath.row];
    
    
    if ( self.pHMZoneDetialViewController == nil )
    {
        RoomAccessoryViewController* pAccessoryViewController = [[RoomAccessoryViewController alloc] init];
        pAccessoryViewController.pHMHome = self.pHMHome;
        pAccessoryViewController.pHMRoom = pHMRoom;
        [self.navigationController pushViewController:pAccessoryViewController animated:YES];
    }
    else
    {
        // TODO - Investigate using the member var pZoneDetailViewController, and leverageing the fact that
        //        I came in here while in edit mode.
        ZoneDetailViewController* pZoneDetialViewController = [[ZoneDetailViewController alloc]init];
        pZoneDetialViewController.pHMHome = self.pHMHome;
        pZoneDetialViewController.pRoomForAddition = pHMRoom;
        pZoneDetialViewController.pHMZone = self.pHMZoneDetialViewController.pHMZone;
 
       [self.navigationController pushViewController:pZoneDetialViewController animated:YES];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)addRoom
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Room"
                                                    message:@"Name for new Room"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UITextField *textfield =  [alertView textFieldAtIndex: 0];
	NSString* temp = [textfield text];
	
	NSMutableArray* pTempRoomsList = self.pRoomsList;
	
	RoomViewController* __weak  pTempSelf = self;
	
	[pHMHome addRoomWithName:temp completionHandler:^(HMRoom* pRoom, NSError* error)
	 {
		 if ( error != nil )
		 {
			 NSLog(@"Error Encountered");
			 NSLog(@"error: %@", error);
		 }
		 else
		 {
			 NSLog(@"Added Room name is: %@", pRoom.name);
			 
			 NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[pTempRoomsList count]  inSection:0];
			 
			 [pTempRoomsList addObject:pRoom];
			 
			 [pTempSelf.tableView insertRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		 }
	 }];
	
    [self.tableView reloadData];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UITableView* pUITableView;
    pUITableView = [[UITableView alloc] initWithFrame:applicationFrame style:UITableViewStylePlain];
    pUITableView.dataSource = self;
    pUITableView.delegate = self;
    
    self.view = pUITableView;
    
    if ( self.pHMHome == nil )
    {
        self.pHMHomeManager = [[HMHomeManager alloc] init];
        self.pHMHomeManager.delegate = self;
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        NSLog(@"cell == nil");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    // TODO - this is not needed the count is set to zero if pHMHome is nil
    bool bIsReady = self.pHMHome != nil;
    
    //NSLog(@"RoomList count is:%lu", (unsigned long)self.pRoomsList.count);
    
    if ( bIsReady && indexPath.row < self.pRoomsList.count )
    {
        HMRoom* pHMRoom = [self.pRoomsList objectAtIndex:indexPath.row];
        NSLog(@" room name for table cell is:%@", [pHMRoom name]);
        cell.textLabel.text = [pHMRoom name];
    }
    else if ( bIsReady && indexPath.row == self.pRoomsList.count )
    {
        cell.textLabel.text = @"Add Room";
    }
    else
    {
        cell.textLabel.text = @"No Rooms in this home";
    }
    
    return cell;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pRoomsList.count)
        return UITableViewCellEditingStyleInsert;
    else /*if ( left swipe ) */
        return UITableViewCellEditingStyleDelete;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
	
	if ( editing )
	{
		NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[self.pRoomsList count]  inSection:0];
		[self.tableView insertRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else
	{
		NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[self.pRoomsList count]  inSection:0];
		[self.tableView deleteRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.pHMHome == nil )
        return 0;
    
    if ( self.editing )
        return [self.pRoomsList count] + 1;
    else
        return self.pRoomsList.count;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)textViewDidChange:(UITextView *)textView
{
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidUnload
{
    [super viewDidUnload];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
