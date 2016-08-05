//
//  AccessoryDetailViewController.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import "AccessoryDetailViewController.h"
#import "ServiceDetailViewController.h"

#import "ServiceProtocol.h"
#import "HKAService.h"

@interface AccessoryDetailViewController ()

@end

@implementation AccessoryDetailViewController

@synthesize pHMAccessory;
@synthesize pHMHome;
@synthesize pServiceContainer;
@synthesize pViewContainer;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pServiceContainer = [[NSMutableArray alloc] init];
    pViewContainer = [[NSMutableArray alloc] init];
    
    NSLog(@"accessory details name is:%@", pHMAccessory.name);
    
    self.title = @"Accessory Details";
    
    NSArray* pServices = pHMAccessory.services;
    HMService* pService;
    NSLog(@"The total count of services is:%lu", (unsigned long)pServices.count);
    
    for ( int i = 0; i< pServices.count; i++ )
    {
        pService =  [pServices objectAtIndex:i];
        NSLog(@"toggleAccessoryState: service name is:%@", pService.name);
        NSLog(@"toggleAccessoryState: service type is:%@", pService.serviceType);

		// TODO - I think this should go away, there are too many controls to display on one page.
        // Keep the array an array of pHKAServices so if desired a setting can be added to display
        // either a list of service names, or all the services controls.
        id <ServiceProtocol> pHKAService = [HKAService create:pService];
        if ( pHKAService != nil )
        {
            [pViewContainer addObject:[pHKAService SetViewControls]];
            [pHKAService setPHMService:pService];
            [pServiceContainer  addObject:pHKAService];
        }
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <ServiceProtocol> pHKAService = [pServiceContainer objectAtIndex:indexPath.row];
    ServiceDetailViewController* pServiceDetailViewController = [[ServiceDetailViewController alloc] init];
    
    //set the acessory delegate to be the service
    // yes this will change each time they select a new service
    [self.pHMAccessory setDelegate:[pServiceContainer objectAtIndex:indexPath.row]];
    
    
    pServiceDetailViewController.pHKAService = pHKAService;
    [self.navigationController pushViewController:pServiceDetailViewController animated:YES];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        NSLog(@"cell == nil");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    NSLog(@"Services List count is:%lu", (unsigned long)pServiceContainer.count);
    
    if ( indexPath.row < pServiceContainer.count )
    {
        id <ServiceProtocol> pHKAService = [pServiceContainer objectAtIndex:indexPath.row];
        
        NSLog(@" Accessory name for table cell is:%@", [pHKAService GetName]);
        
       cell.textLabel.text = [pHKAService GetName];
    }
    else
    {
        cell.textLabel.text = @"No services";
    }
    
    return cell;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pServiceContainer.count;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:(animated)];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

@end
