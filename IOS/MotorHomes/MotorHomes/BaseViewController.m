//
//  BaseViewController.m
//  StreetBee
//
//  Created by admin on 8/14/13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIButton * leftNavButton;
@property (nonatomic, strong) UIButton * rightNavButton;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if(!self.navigationController)
		return;
	
	[self.navigationItem setHidesBackButton:YES animated:NO];
		
	self.leftNavButton = (UIButton*)[self.navigationController.navigationBar viewWithTag:10];
	self.rightNavButton = (UIButton*)[self.navigationController.navigationBar viewWithTag:20];
	self.titleLabel = (UILabel*)[self.navigationController.navigationBar viewWithTag:30];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if(self.leftNavButton)
	{
		[self.leftNavButton addTarget:self action:@selector(leftNavButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
		if(self.navigationController.viewControllers.count > 1)
		{
			[self.leftNavButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
		}
		else
		{
			[self.leftNavButton setImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
		}
	}
	
	if(self.rightNavButton)
	{
		[self.rightNavButton addTarget:self action:@selector(rightNavButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
		if(self.rightNavButtonImage)
		   [self.rightNavButton setImage:self.rightNavButtonImage forState:UIControlStateNormal];
	}

	if(self.titleLabel)
		self.titleLabel.text = self.title;
	
	self.navigationItem.title = @"";
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if(self.leftNavButton)
	{
		[self.leftNavButton removeTarget:self action:@selector(leftNavButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	}
	
	if(self.rightNavButton)
	{
		[self.rightNavButton removeTarget:self action:@selector(rightNavButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
		[self.rightNavButton setImage:nil forState:UIControlStateNormal];
	}
}

- (void)leftNavButtonPressed
{
	if(!self.navigationController)
		return;
	
    if (self.navigationController.viewControllers.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [appDelegate.menuController toggleLeftSideMenuCompletion:nil];
    }
}

- (void)rightNavButtonPressed
{
	ALog(@"Right navigation button pressed");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)shouldAutorotate
{
	if(IS_IPAD)
		return YES;
	
	return NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(IS_IPAD)
		return YES;
	
	return NO;
}

@end
