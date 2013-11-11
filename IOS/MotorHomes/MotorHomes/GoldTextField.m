//
//  YellowTextField.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "GoldTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation GoldTextField

-(void)awakeFromNib
{
	self.layer.borderWidth = 1.0;
	self.layer.borderColor = RGB(220, 180, 70).CGColor;
}

@end
