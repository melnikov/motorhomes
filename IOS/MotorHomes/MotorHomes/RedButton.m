//
//  RedButton.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "RedButton.h"

@implementation RedButton

-(void)awakeFromNib
{
	UIImage *image = [[UIImage imageNamed:@"redButton"] stretchableImageWithLeftCapWidth:7 topCapHeight:0];
    [self setBackgroundImage:image forState:UIControlStateNormal];
	
	self.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:self.titleLabel.font.pointSize];
	self.titleLabel.shadowOffset = CGSizeMake(0, 0);
	self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
