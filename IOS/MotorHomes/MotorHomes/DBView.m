//
//  DBView.m
//  MotorHomes
//
//  Created by admin on 07.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "DBView.h"

@interface DBView ()

@property (nonatomic, strong) UIImageView * separatorView;
@property (assign) BOOL isSeparatorHidden;

@end

@implementation DBView

-(void)awakeFromNib
{
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	
	self.separatorView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"separator.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0]];
	
	//self.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	
	self.separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	[self addSubview:self.separatorView];
	
	[self sendSubviewToBack:self.separatorView];
	
	self.separatorView.frame = CGRectMake(0, 0, self.frame.size.width, 3);
	
	[self setSeparatorHidden:self.isSeparatorHidden];
}

-(void)setSeparatorHidden:(BOOL)hidden
{
	self.separatorView.hidden = hidden;
}

@end
