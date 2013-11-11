//
//  YellowButton.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "GoldButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation GoldButton

-(void)awakeFromNib
{
	UIImage *image = [[UIImage imageNamed:@"goldButton"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    [self setBackgroundImage:image forState:UIControlStateNormal];
	
	self.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:self.titleLabel.font.pointSize];
	self.titleLabel.shadowOffset = CGSizeMake(0, 1);
	self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
