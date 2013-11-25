//
//  LOMCell.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "LOMCell.h"

@implementation LOMCell

-(void)awakeFromNib
{
	UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = RGBA(17, 17, 17, 0.4);
    self.selectedBackgroundView =  customColorView;
}

@end
