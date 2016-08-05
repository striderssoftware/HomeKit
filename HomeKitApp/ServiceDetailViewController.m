//
//  ServiceDetailViewController.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import "ServiceDetailViewController.h"

#import "ServiceProtocol.h"
#import "HKAService.h"

@interface ServiceDetailViewController ()

@end

@implementation ServiceDetailViewController

@synthesize pHKAService;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIScrollView* pScrollview = [[UIScrollView alloc] init];
	self.view = pScrollview;
	
	
	NSLog(@"service detail name is:%@", [pHKAService GetName]);
	
	self.title = @"Service Controls";
	
	[self.view setBackgroundColor:[UIColor blueColor]];
	
	UIView* pServiceView = [pHKAService SetViewControls];
	[self.view addSubview:pServiceView];
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
