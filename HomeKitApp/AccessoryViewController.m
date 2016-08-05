//
//  AccessoryViewController.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import "AccessoryViewController.h"
#import "AccessoryDetailViewController.h"
#import "RoomViewController.h"
#import "RoomAccessoryViewController.h"
#import "SettingsViewController.h"

@interface AccessoryViewController ()

@end


@implementation AccessoryViewController

@synthesize pHMRoom;
@synthesize pHMHome;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _AccessorysList = [[NSMutableArray alloc] init];
    
    if ( pHMRoom == nil )
    {
        self.title = @"New Accessories";
        _pHMAccessoryBrowser = [[HMAccessoryBrowser alloc] init];
        _pHMAccessoryBrowser.delegate = self;
        [_pHMAccessoryBrowser startSearchingForNewAccessories];
    }
    else
    {
        self.title = @"Home Accessories";
        
        _AccessorysList = (NSMutableArray*)pHMHome.accessories;
        
        // Only display home accessories not assigned to a room.
        NSMutableArray* pUnAssigendAccessories = [[NSMutableArray alloc] init];
        for (int i =0; i < _AccessorysList.count; i++ )
        {
            HMAccessory* pHMAccessory = [_AccessorysList objectAtIndex:i];
            NSLog(@"Home accessory name is:%@", pHMAccessory.name);
            if ( [pHMAccessory.room.name isEqualToString:pHMHome.name] )
                [pUnAssigendAccessories addObject:pHMAccessory];
            else
                NSLog(@"Accessory room is:%@", pHMAccessory.room.name);
        }
        
        _AccessorysList = pUnAssigendAccessories;
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)assignAccessoryToRoom:(HMAccessory*) pHMAccessory
{
    AccessoryViewController* __weak  pTempSelf = self;
    
    NSLog(@"Assigning Accessory to Room");
    [pHMHome assignAccessory:pHMAccessory toRoom:pHMRoom completionHandler:^(NSError* error)
     {
         if ( error != nil )
         {
             NSLog(@"Error Encountered");
             NSLog(@"error: %@", error);
         }
         else
         {
             NSLog(@"added accessory to Room");
             [pTempSelf assignementSegue:pHMAccessory];
         }
     }];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)loadView
{
    [super loadView];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UITableView* pUITableView;
    pUITableView = [[UITableView alloc] initWithFrame:applicationFrame style:UITableViewStylePlain];
    pUITableView.dataSource = self;
    pUITableView.delegate = self;
    
    self.view = pUITableView;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        NSLog(@"cell == nil");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    NSLog(@"AccessoryList count is:%lu", (unsigned long)_AccessorysList.count);
    
    if ( indexPath.row < _AccessorysList.count )
    {
        HMAccessory* pHMAccessory = [_AccessorysList objectAtIndex:indexPath.row];
        NSLog(@" Accessory name for table cell is:%@", [pHMAccessory name]);
        
        NSString* cellText =  pHMAccessory.name;
        
        cell.textLabel.text = cellText;
    }
    else
    {
        cell.textLabel.text = @"No Accessorys for rent";
    }
    
    return cell;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_AccessorysList count];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        if ( pHMRoom == nil )
            return @"Selecting will add to Home";
        else
            return @"Selecting will add to Room";
    }
    
    //Should never get here
    return @"ERROR";
}

// HMAccessoryBrowserDelegate
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory
{
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory
{
    NSLog(@"accessory found");
    NSLog(@"accessory name is: %@", accessory.name);
    
    [_AccessorysList addObject:accessory];
    
    NSLog(@"AccessoryList count is:%lu", (unsigned long)_AccessorysList.count);
    
    [self.tableView reloadData];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMAccessory* pHMAccessory = [_AccessorysList objectAtIndex:indexPath.row];
    
    NSLog(@"Accessory name is :%@", pHMAccessory.name);
    NSLog(@"Home name is:%@", pHMHome.name);
    NSLog(@"Room name is :%@", pHMRoom.name);
    
    AccessoryViewController* __weak  pTempSelf = self;

    if ( pHMHome != nil && pHMRoom == nil )
    {
        [pHMHome  addAccessory:pHMAccessory completionHandler:^(NSError* error)
         {
             if ( error != nil )
             {
                 NSLog(@"Error Encountered");
                 NSLog(@"error: %@", error);
                 return;
             }
             else
             {
                 NSLog(@"added assesory to HOME");
                 
                 [CATransaction begin];
                 
                 [CATransaction setCompletionBlock:^{
                     sleep(1);
                     [pTempSelf segueToHome];
                 }];
                 
 
                 [pTempSelf.AccessorysList removeObjectAtIndex:indexPath.row];
                 [pTempSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
   
                 [CATransaction commit];
             }
             
         }];
    }
    else if ( pHMRoom != nil)
    {
        [self assignAccessoryToRoom:pHMAccessory];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)assignementSegue:(HMAccessory*) pHMAccessory
{
    //TODO when an accessory is assigned, manage the table and remove it. the back buton can show stale data.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* szGoToAccessoryDetail = [defaults valueForKey:GO_TO_ACCESSORY_DETAIL];
    
    if ( szGoToAccessoryDetail.boolValue )
    {
        
        AccessoryDetailViewController* pAccessoryDetailViewController = [[AccessoryDetailViewController alloc] init];
        pAccessoryDetailViewController.pHMHome = self.pHMHome;
        pAccessoryDetailViewController.pHMAccessory = pHMAccessory;
        [self.navigationController pushViewController:pAccessoryDetailViewController animated:YES];
    }
    else
    {
        RoomAccessoryViewController* pAccessoryViewController = [[RoomAccessoryViewController alloc] init];
        pAccessoryViewController.pHMHome = self.pHMHome;
        pAccessoryViewController.pHMRoom = self.pHMRoom;
        [self.navigationController pushViewController:pAccessoryViewController animated:YES];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)segueToHome
{
    RoomViewController* pRoomViewController = [[RoomViewController alloc] init];
    pRoomViewController.pHMHome = pHMHome;
    [self.navigationController pushViewController:pRoomViewController animated:YES];
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
