//
//  SettingsViewController.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import "SettingsViewController.h"

#import "ServiceProtocol.h"
#import "HKAService.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize pSwitch;
@synthesize pSwitch2;
@synthesize pSwitch3; // TODO - use this switch or delete it.

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    NSLog(@"Settings page viewDidLoad");
    
    UIScrollView* pScrollview = [[UIScrollView alloc] init];
    self.view = pScrollview;
    self.title = @"Settings";
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    
    // A SETTING
    UILabel* pLabel = [[UILabel alloc] init];
    [pLabel setText:@"New Accessory goes to Detail:"];
    [pLabel setTextColor:[UIColor whiteColor]];
    [pLabel setBackgroundColor:[UIColor blueColor]];
    pLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [pLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:pLabel];
    
    [pLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.pSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [pSwitch addTarget:self action:@selector(SetSwitchState) forControlEvents:UIControlEventTouchUpInside];
    
    [pSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:pSwitch];
    
    [pSwitch setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pSwitch setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // A SETTING
    UILabel* pLabel2 = [[UILabel alloc] init];
    [pLabel2 setText:@"Start with Primary Home:"];
    [pLabel2 setTextColor:[UIColor whiteColor]];
    [pLabel2 setBackgroundColor:[UIColor blueColor]];
    pLabel2.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [pLabel2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:pLabel2];
    
    [pLabel2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pLabel2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.pSwitch2 = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [pSwitch2 addTarget:self action:@selector(SetSwitchState) forControlEvents:UIControlEventTouchUpInside];
    
    [pSwitch2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:pSwitch2];
    
    [pSwitch2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pSwitch2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    // A SETTING
    UILabel* pLabel3 = [[UILabel alloc] init];

    [pLabel3 setText:@"New Accessory goes to Detail:"];
    [pLabel3 setTextColor:[UIColor whiteColor]];
    [pLabel3 setBackgroundColor:[UIColor blueColor]];
    pLabel3.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [pLabel3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:pLabel3];
    
    [pLabel3 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pLabel3 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.pSwitch3 = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [pSwitch3 addTarget:self action:@selector(SetSwitchState) forControlEvents:UIControlEventTouchUpInside];
    
    [pSwitch3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:pSwitch3];
    
    [pSwitch3 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pSwitch3 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    
   NSDictionary* pViewDictionary = NSDictionaryOfVariableBindings(pLabel,pSwitch,pLabel2,pSwitch2,pLabel3,pSwitch3);
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pLabel]-10-[pSwitch]-0-|"
                                             options : NSLayoutFormatAlignAllCenterY
                                             metrics : nil
                                               views : pViewDictionary]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pLabel2]-10-[pSwitch2]-0-|"
                                             options : NSLayoutFormatAlignAllCenterY
                                             metrics : nil
                                               views : pViewDictionary]];

    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pLabel3]-10-[pSwitch3]-0-|"
                                             options : NSLayoutFormatAlignAllCenterY
                                             metrics : nil
                                               views : pViewDictionary]];

    

    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat : @"V:|-10-[pLabel]-10-[pLabel2]-10-[pLabel3]-0-|"
                                             options : 0
                                             metrics : nil
                                               views : pViewDictionary]];
    
    [self.view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.pSwitch.on = [[defaults valueForKey:GO_TO_ACCESSORY_DETAIL] boolValue];
    self.pSwitch2.on = [[defaults valueForKey:GO_TO_PRIMARY_HOME] boolValue];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
    [self saveSettings];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetSwitchState
{
    NSLog(@"Toggled Switch Control");
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-(void) saveSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.pSwitch .isOn ? @"TRUE" : @"FALSE" forKey:GO_TO_ACCESSORY_DETAIL];
    [defaults setValue:self.pSwitch2 .isOn ? @"TRUE" : @"FALSE" forKey:GO_TO_PRIMARY_HOME];
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
