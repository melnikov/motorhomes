//
//  GoldBorderButton.m
//  MotorHomes
//
//  Created by admin on 12.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "GoldBorderButton.h"

@implementation GoldBorderButton

-(void)awakeFromNib
{
	UIImage *image = [[UIImage imageNamed:@"goldBorderButton"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    [self setBackgroundImage:image forState:UIControlStateNormal];
	
	self.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:self.titleLabel.font.pointSize];
	self.titleLabel.shadowOffset = CGSizeMake(0, 1);
	self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
