//
//  LBCell.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "LBCell.h"

@interface LBCell ()

@property (nonatomic, strong) UIImageView * separatorImageView;
@property (assign) BOOL isSeparatorHidden;

@end

@implementation LBCell

-(void)awakeFromNib
{
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLight.png"]];
	
	self.separatorImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"separator.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0]];
	
	self.separatorImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self addSubview:self.separatorImageView];
	
	[self sendSubviewToBack:self.separatorImageView];
	
	self.separatorImageView.frame = CGRectMake(0, 0, self.frame.size.width, 3);
	
	[self setSeparatorHidden:self.isSeparatorHidden];
}

-(void)setSeparatorHidden:(BOOL)hidden
{
	self.separatorImageView.hidden = hidden;
}

@end
