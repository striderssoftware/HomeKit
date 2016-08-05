//
//  ZoneDetailViewController.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import "ZoneDetailViewController.h"
#import "RoomViewController.h"
#import "RoomAccessoryViewController.h"

@interface ZoneDetailViewController ()

@end

@implementation ZoneDetailViewController

@synthesize pHMZone;
@synthesize pRooms;
@synthesize pRoomForAddition;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
    self.pRooms = [[NSMutableArray alloc] initWithArray:self.pHMZone.rooms copyItems:NO];

    if ( self.pRoomForAddition != nil )
        [self addRoom];
    
    NSLog(@"Zone details name is:%@", pHMZone.name);
    
    self.title = @"Zone Details";
    
    // TOOLBAR
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"All ON" style:UIBarButtonItemStyleDone target:self action:@selector(allOn)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"All OFF" style:UIBarButtonItemStyleDone target:self action:@selector(allOff)];
    

    [self setToolbarItems:[[NSArray alloc] initWithObjects:button1,spacer,button2,nil]];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)allOn
{
    NSLog(@"All On called");
    
    [self setCharacteristicValueTo:true];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)allOff
{
    NSLog(@"All Off called");
    
    [self setCharacteristicValueTo:false];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)setCharacteristicValueTo:(bool) bSetValue
{
    for ( int i =0; i < self.pRooms.count; i++ )
    {
        HMRoom* pHMRoom = [self.pRooms objectAtIndex:i];
        
        for ( int j =0; j < pHMRoom.accessories.count; j++ )
        {
            HMAccessory* pHMAccessory = [pHMRoom.accessories objectAtIndex:j];
            NSLog(@"All OFF: Accessory name is:%@", pHMAccessory.name);
            
            for ( int k =0; k < pHMAccessory.services.count; k++ )
            {
                HMService* pHMService =  [pHMAccessory.services objectAtIndex:k];
                NSLog(@"All Off: service name is:%@", pHMService.name);
                
                for ( int l =0; l < pHMService.characteristics.count; l++ )
                {
                    HMCharacteristic* pHMCharacteristic = [pHMService.characteristics objectAtIndex:l];
                    NSLog(@"All OFF: characteristic type is:%@", pHMCharacteristic.characteristicType );
                    
                    if ( [pHMCharacteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] )
                    {
                        NSLog(@"THE POWER STATE IS THE ONLY CHARACTERISTIC TO BE TOGGLED");
                        NSNumber* temp = [NSNumber numberWithBool:bSetValue];
                        [pHMCharacteristic writeValue:temp completionHandler:^(NSError* error){
                            if ( error != nil )
                            {
                                NSLog(@"Error Encountered");
                                NSLog(@"error: %@", error);
                            }
                            else
                            {
                                NSLog(@"SetCharacteristicValueTo changed state of power state to:%d",bSetValue);
                            }
                        }];
                    }
                }
                
            }
        }
        
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)addRoom
{
    NSLog(@"Adding a Room to zone room name is:%@", [self.pRoomForAddition name]);
    
    ZoneDetailViewController* __weak  pTempSelf = self;
    NSMutableArray* pTempRoomsList = self.pRooms;
    HMRoom* pTempRoomForAddition = self.pRoomForAddition;

    
    [self.pHMZone addRoom:self.pRoomForAddition completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"added Room, name is:%@", [pTempRoomForAddition name]);
            
            NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[pTempRoomsList count]  inSection:0];
            [pTempRoomsList addObject:pTempRoomForAddition];
            [pTempSelf.tableView insertRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    
    self.pRoomForAddition = nil;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.pRooms.count)
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
        NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[self.pRooms count]  inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        NSIndexPath* pIndexPath = [NSIndexPath indexPathForRow:[self.pRooms count]  inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[pIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        HMRoom* pHMRoom = [self.pRooms objectAtIndex:indexPath.row];
        NSLog(@" Room name for table cell is:%@", [pHMRoom name]);
        
        [self.pHMZone removeRoom:pHMRoom completionHandler:^(NSError* error){
            if ( error != nil )
            {
                NSLog(@"Error Encountered");
                NSLog(@"error: %@", error);
            }
            else
            {
                NSLog(@"Removed Room, name is:%@", [pHMRoom name]);
                
                [self.pRooms removeObjectAtIndex:indexPath.row];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
    else if ( UITableViewCellEditingStyleInsert )
    {
        [self addRoomToZoneSegue];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)addRoomToZoneSegue
{
    RoomViewController* pRoomViewController = [[RoomViewController alloc] init];
    pRoomViewController.pHMHome = self.pHMHome;
    pRoomViewController.pHMZoneDetialViewController = self;
    
    [self.navigationController pushViewController:pRoomViewController animated:YES];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMRoom* pHMRoom = [self.pRooms objectAtIndex:indexPath.row];
    
    RoomAccessoryViewController* pAccessoryViewController = [[RoomAccessoryViewController alloc] init];
    pAccessoryViewController.pHMHome = self.pHMHome;
    pAccessoryViewController.pHMRoom = pHMRoom;
    [self.navigationController pushViewController:pAccessoryViewController animated:YES];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        NSLog(@"cell == nil");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    NSLog(@"Zone/Rooms List count is:%lu", (unsigned long)self.pRooms.count);
    
    if ( indexPath.row < self.pRooms.count )
    {
        HMRoom* pHMRoom = [self.pRooms objectAtIndex:indexPath.row];
        
        NSLog(@"Zone/Room name for table cell is:%@", [pHMRoom name]);
        
       cell.textLabel.text = [pHMRoom name];
    }
    else if ( indexPath.row == self.pRooms.count )
    {
        cell.textLabel.text = @"Add Room";
    }
    else
    {
        cell.textLabel.text = @"hmmm";
    }
    
    return cell;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( self.editing )
        return [self.pRooms count] + 1;
    else
        return self.pRooms.count;
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
