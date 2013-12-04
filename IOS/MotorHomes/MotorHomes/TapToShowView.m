//
//  TapToShowView.m
//  MotorHomes
//
//  Created by admin on 04.12.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "TapToShowView.h"

@interface TapToShowView ()
{
	IBOutlet UIImageView *arrowImage;
	IBOutlet UIImageView *blackGradient;
	CGAffineTransform transform;
}

@end

@implementation TapToShowView

-(void)awakeFromNib
{
	self.frame = blackGradient.frame;
	
	transform = arrowImage.transform;
}

- (IBAction)buttonShowPressed
{
	float height = [self.contentText.text sizeWithFont:self.contentText.font constrainedToSize:CGSizeMake(self.contentText.frame.size.width, 9999) lineBreakMode:self.contentText.lineBreakMode].height;
	
	self.contentText.frame = CGRectMake(self.contentText.frame.origin.x, self.contentText.frame.origin.y, self.contentText.frame.size.width, height);
	
	float changeHeight = self.frame.size.height;
	
	if(self.frame.size.height == blackGradient.frame.size.height)
		[UIView animateWithDuration:0.2f animations:^{
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentText.frame.origin.y + height + 5);
			arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
		}];
	else
		[UIView animateWithDuration:0.2f animations:^{
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, blackGradient.frame.size.width, blackGradient.frame.size.height);
			arrowImage.transform = transform;
		}];
	
	changeHeight = self.frame.size.height - changeHeight;
	
	NSDictionary * dict = @{@"view" : self, @"change" : [NSNumber numberWithFloat:changeHeight]};
	
	if([self.delegate respondsToSelector:@selector(tapToShowViewFrameChanged:)])
		[self.delegate performSelector:@selector(tapToShowViewFrameChanged:) withObject:dict];
}

@end
