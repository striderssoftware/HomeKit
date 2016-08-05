//
//  RoomAccessoryViewController.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RoomAccessoryViewController.h"
#import "AccessoryViewController.h"
#import "AccessoryDetailViewController.h"
#import "RoomViewController.h"

@interface RoomAccessoryViewController ()

@end

@implementation RoomAccessoryViewController

@synthesize pHMRoom;
@synthesize pHMHome;
@synthesize pAccessorysList;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    self.title =  [NSString stringWithFormat:@"%@ Accessories", [self.pHMRoom name]];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //This page should alway go back to rooms page.
    UIBarButtonItem *alwaysBackToRooms = [[UIBarButtonItem alloc] initWithTitle:@"Rooms" style:UIBarButtonItemStylePlain target:self action:@selector(alwaysBackToRooms)];
    self.navigationItem.leftBarButtonItem = alwaysBackToRooms;
  
    UIBarButtonItem *button3 = [[UIBarButtonItem alloc] initWithTitle:@"Accessories" style:UIBarButtonItemStyleDone target:self action:@selector(toolbarAssignAccessory)];
    //UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //UIBarButtonItem *button4=[[UIBarButtonItem alloc]initWithTitle:@"Zones" style:UIBarButtonItemStyleDone target:self action:@selector(toolbarAssignAccessory)];
    [self setToolbarItems:[[NSArray alloc] initWithObjects:button3,nil]];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)alwaysBackToRooms
{
    RoomViewController* pRoomViewController = [[RoomViewController alloc] init];
    pRoomViewController.pHMHome = self.pHMHome;
    
    [self.navigationController pushViewController:pRoomViewController animated:YES];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editing ? [self.pAccessorysList count] + 1 : [self.pAccessorysList count];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pAccessorysList.count)
        return UITableViewCellEditingStyleInsert;
    else /*if ( left swipe ) */
        return UITableViewCellEditingStyleDelete;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
    if(editing) {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.pAccessorysList.count inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    } else {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.pAccessorysList.count inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //delete the accessory from the room in the ios database
        [self deleteAccessory:self.pAccessorysList[indexPath.row]];
        
        //delete the accessory from this views local list and table.
        [self.pAccessorysList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    else if ( UITableViewCellEditingStyleInsert )
    {
        // Can not add accessoey but can assign
        [self assignAccessory];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)deleteAccessory:(HMAccessory*) pHMAccessory
{
    [pHMHome removeAccessory:pHMAccessory completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Delete Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Delete Successfull");
        }
    }];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)toolbarAssignAccessory
{
     NSLog(@"toolbarAssignAssessory");

    AccessoryViewController* pAccessoryViewController = [[AccessoryViewController alloc] init];
    pAccessoryViewController.pHMHome = pHMHome;
    pAccessoryViewController.pHMRoom = pHMRoom;
    
    //TODO handel table and do that cool thing where it disappears and then you segue
    
    [self.navigationController pushViewController:pAccessoryViewController animated:YES];
 }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)assignAccessory
{
        [self setEditing:NO animated:YES];
    
        AccessoryViewController* pAccessoryViewController = [[AccessoryViewController alloc] init];
        pAccessoryViewController.pHMHome = pHMHome;
        pAccessoryViewController.pHMRoom = pHMRoom;

        //TODO handel table and do that cool thing where it disappears and then you segue
    
    [self.navigationController pushViewController:pAccessoryViewController animated:YES];
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
    
    // INITIALIZE THE Accessory LIST
    self.pAccessorysList = [[NSMutableArray alloc] initWithArray:pHMRoom.accessories copyItems:NO];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row < self.pAccessorysList.count )
    {
        AccessoryDetailViewController* pAccessoryDetailViewController = [[AccessoryDetailViewController alloc] init];
        pAccessoryDetailViewController.pHMHome = pHMHome;
        pAccessoryDetailViewController.pHMAccessory = [self.pAccessorysList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:pAccessoryDetailViewController animated:YES];
    }
    else
        NSLog(@"No accessorys to select - message row");
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        NSLog(@"cell == nil");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    NSLog(@"AccessoryList count is:%lu", (unsigned long)self.pAccessorysList.count);
    
    if ( indexPath.row < self.pAccessorysList.count )
    {
        HMAccessory* pHMAccessory = [self.pAccessorysList objectAtIndex:indexPath.row];
        NSLog(@" Accessory name for table cell is:%@", [pHMAccessory name]);
        cell.textLabel.text = [pHMAccessory name];
    }
    else if ( indexPath.row == self.pAccessorysList.count )
    {
        cell.textLabel.text = @"Assign accessory";
    }
    else
    {
        cell.textLabel.text = @"No homes for rent";
    }
    
    return cell;
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
