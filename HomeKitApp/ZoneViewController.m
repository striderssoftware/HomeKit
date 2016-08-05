//
//  ZoneViewController.m
//  ZoneKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import "ZoneViewController.h"
#import "ZoneDetailViewController.h"

#import "SettingsViewController.h"

@interface ZoneViewController ()

@end

@implementation ZoneViewController

@synthesize zones;

static const int iAddZoneTag = 0;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Zones";
    
    self.zones = [[NSMutableArray alloc] initWithArray:self.pHMHome.zones copyItems:NO];
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(segueToSettingsPage)];
    [self setToolbarItems:[[NSArray alloc] initWithObjects:button1,nil]];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-(void) segueToSettingsPage
{
    SettingsViewController* pSettingsViewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:pSettingsViewController animated:YES];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)assignAccessory
{
    NSLog(@"ZoneViewController:AssignAccessory");   
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)addZone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Zone"
                                                    message:@"Name Your New Zone"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = iAddZoneTag;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == iAddZoneTag )
    {
        UITextField *textfield =  [alertView textFieldAtIndex: 0];
        
        NSString* temp = [textfield text];
        NSMutableArray* pTempZonesList = self.zones;
        
        ZoneViewController* __weak  pTempSelf = self;
        
        [self.pHMHome addZoneWithName:temp completionHandler:^(HMZone* pZone, NSError* error){
            if ( error != nil )
            {
                NSLog(@"Error Encountered");
                NSLog(@"error: %@", error);
            }
            else
            {
                NSLog(@"Added Zone name is: %@", pZone.name);
                
                NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[pTempZonesList count]  inSection:0];
                
                [pTempZonesList addObject:pZone];
                
                [pTempSelf.tableView insertRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)deleteZone:(HMZone *) pHMZone atIndexPath:(NSIndexPath *)indexPath
{
    ZoneViewController* __weak  pTempSelf = self;
    
    [self.pHMHome removeZone:pHMZone completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Removed Zone name is: %@", pHMZone.name);
            [pTempSelf.zones removeObjectAtIndex:indexPath.row];
            [pTempSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
     }];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)loadView
{
    [super loadView];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    NSLog(@"ZoneList count is:%lu", (unsigned long)self.zones.count);
    
    if ( indexPath.row < self.zones.count )
    {
        HMZone* pHMZone = [self.zones objectAtIndex:indexPath.row];
        NSLog(@" Zone name for table cell is:%@", [pHMZone name]);
        
        cell.textLabel.text = pHMZone.name;
        
        //additional debuging
        NSLog(@"Zone is:%@", pHMZone.name);
        
    }
    else if ( indexPath.row == self.zones.count )
    {
        cell.textLabel.text = @"Add Zone";
    }
    else
    {
        cell.textLabel.text = @"No Zones for rent";
    }
    
    return cell;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editing ? [self.zones count] + 1 : [self.zones count];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.zones.count)
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
		NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[self.zones count]  inSection:0];
		[self.tableView insertRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else
	{
		NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[self.zones count]  inSection:0];
		[self.tableView deleteRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteZone:self.zones[indexPath.row] atIndexPath:indexPath];
    }
    else if ( UITableViewCellEditingStyleInsert )
    {
        [self addZone];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMZone* pZone = [self.zones objectAtIndex:indexPath.row];
    ZoneDetailViewController* pZoneDetailsViewController = [[ZoneDetailViewController alloc] init];
    pZoneDetailsViewController.pHMZone = pZone;
    pZoneDetailsViewController.pHMHome = self.pHMHome;
    [self.navigationController pushViewController:pZoneDetailsViewController animated:YES];
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
