//
//  ViewController.m
//  MotorHomes
//
//  Created by admin on 07.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "SignInController.h"
#import "LBView.h"
#import "RegisterController.h"

@interface SignInController ()

@end

@implementation SignInController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
	
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.title = @"SIGN IN";
}

- (IBAction)registerNowPressed
{
	[self.navigationController pushViewController:[RegisterController new] animated:YES];
}

@end
