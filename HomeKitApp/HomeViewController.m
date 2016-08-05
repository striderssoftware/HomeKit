//
//  HomeViewController.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import "HomeViewController.h"
#import "RoomViewController.h"

#import "SettingsViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize pHMHomeManager;
@synthesize pHomesList;

static const int iAddHomeTag = 0;
static const int iDataBaseHomeAdded = 1;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Homes";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleDone target:self action:@selector(segueToSettingsPage)];
   
    [self setToolbarItems:[[NSArray alloc] initWithObjects:button1,nil]];
    
    
    // INITIALIZE HOME MANAGER
    self.pHMHomeManager =  [[HMHomeManager alloc] init];
    self.pHMHomeManager.delegate = self;
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
    NSLog(@"HomeViewController:AssignAccessory");   
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)addHome
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Home"
                                                    message:@"Name Your New Home"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = iAddHomeTag;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == iAddHomeTag )
    {
        
        UITextField *textfield =  [alertView textFieldAtIndex: 0];
        
        NSString* temp = [textfield text];
        NSMutableArray* pTempHomesList = self.pHomesList;
        
        HomeViewController* __weak  pTempSelf = self;
        
        [self.pHMHomeManager addHomeWithName:temp completionHandler:^(HMHome* pHome, NSError* error){
            
            if ( error != nil )
            {
                NSLog(@"Error Encountered");
                NSLog(@"error: %@", error);
            }
            else
            {
                NSLog(@"Added Home name is: %@", pHome.name);
                
                NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[pTempHomesList count]  inSection:0];
                
                [pTempHomesList addObject:pHome];
                
                [pTempSelf.tableView insertRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
    
    else if ( alertView.tag == iDataBaseHomeAdded )
    {
        NSLog(@"New Home was added outside of this app");
        if ( buttonIndex == 0 )
        {
            //segue to homes page
            HomeViewController* pHomeViewController = [[HomeViewController alloc] init];
            [self.navigationController pushViewController:pHomeViewController animated:YES];
        }
        else if ( buttonIndex == 1 )
        {
             NSLog(@"User ignored new database home addition");
            // Do Nothing
         }
    }
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
    
    NSLog(@"HomeList count is:%lu", (unsigned long)self.pHomesList.count);
    
    if ( indexPath.row < self.pHomesList.count )
    {
        HMHome* pHMHome = [self.pHomesList objectAtIndex:indexPath.row];
        NSLog(@" home name for table cell is:%@", [pHMHome name]);
        
        NSString* cellText =  pHMHome.name;
		
        if ( [pHMHome isPrimary] )
        {
            NSLog(@"%@ is the Primary Home", pHMHome.name);
            cellText  = [cellText stringByAppendingString:@" - Primary Home"];
        }
        
        cell.textLabel.text = cellText;
        
        //additional debuging
        NSLog(@"Room for (Entire) home:%@ is:%@", pHMHome.name, [[pHMHome roomForEntireHome] name]);
        
    }
    else if ( indexPath.row == self.pHomesList.count )
    {
        cell.textLabel.text = @"Add Home";
    }
    else
    {
        cell.textLabel.text = @"No homes for rent";
    }
    
    return cell;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editing ? [self.pHomesList count] + 1 : [self.pHomesList count];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pHomesList.count)
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
		NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[self.pHomesList count]  inSection:0];
		[self.tableView insertRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	else
	{
		NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[self.pHomesList count]  inSection:0];
		[self.tableView deleteRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        HMHome* pHMHome = [self.pHomesList objectAtIndex:indexPath.row];
        NSLog(@" home name for table cell is:%@", [pHMHome name]);

        [self.pHMHomeManager removeHome:pHMHome completionHandler:^(NSError* error){
            if ( error != nil )
            {
                NSLog(@"Error Encountered");
                NSLog(@"error: %@", error);
            }
            else
            {
                NSLog(@"Removed home, name is:%@", [pHMHome name]);
				
				[self.pHomesList removeObjectAtIndex:indexPath.row];
				
				[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }];
    }
    else if ( UITableViewCellEditingStyleInsert )
    {
        [self addHome];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home
{
	//Only called for outside changes to the data
	
	//TODO - manage the table here,

    NSLog(@"didAddHome called");
    
    if ( home == nil )
    {
        NSLog(@"Error - Home is nil");
    }
    else
    {
        NSLog(@"didAddHome called - home name is:%@", home.name);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Home Added"
                                                        message:[NSString stringWithFormat:@"New Home was Added: %@", home.name]
                                                       delegate:self
                                              cancelButtonTitle:@"Go To Homes"
                                              otherButtonTitles:@"Ignore", nil];
        alert.tag = iDataBaseHomeAdded;
        
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        
    }
    
    [self.tableView reloadData];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home
{
	//Only called for outside changes to the data
	
	//TODO - manage the table here,
    
    NSLog(@"didRemoveHome called - home name is:%@", home.name);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Home Deleted"
                                                    message:[NSString stringWithFormat:@"Home was Deleted: %@", home.name]
                                                   delegate:self
                                          cancelButtonTitle:@"Go To Homes"
                                          otherButtonTitles:@"Ignore", nil];
    alert.tag = iDataBaseHomeAdded;
    
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];

    
    [self.tableView reloadData];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) homeManagerDidUpdateHomes:(HMHomeManager *)manager
{
	self.pHomesList = [[NSMutableArray alloc] initWithArray:[self.pHMHomeManager homes] copyItems:NO];
    
    NSLog(@"HomeList count is:%lu", (unsigned long)self.pHomesList.count);
    
    for (int i = 0; i < self.pHomesList.count; i++)
    {
        HMHome* pHMHome = [self.pHomesList objectAtIndex:i];
        NSLog(@" home name from manager is: %@", pHMHome.name);
    }
    
    NSLog(@"HomeList count is:%lu", (unsigned long)self.pHomesList.count);
    
    [self.tableView reloadData];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager
{
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
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) setPrimaryHome:(HMHome *)pHMHome
{
    if ( ![pHMHome isPrimary])
    {
        NSLog(@"updating primary home");
        [self.pHMHomeManager updatePrimaryHome:pHMHome
                           completionHandler:^(NSError *error){
                               if ( error != nil )
                               {
                                   NSLog(@"Error Encountered");
                                   NSLog(@"error: %@", error);
                               }
                               else
                               {
                                   NSLog(@"updating primary home name is: %@", pHMHome.name);
                               }
                           }];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMHome* pHome = [self.pHomesList objectAtIndex:indexPath.row];
    RoomViewController* pRoomViewController = [[RoomViewController alloc] init];
    pRoomViewController.pHMHome = pHome;
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
