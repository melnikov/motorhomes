//
//  VideoController.h
//  MotorHomes
//
//  Created by admin on 23.12.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoController : BaseViewController <UIWebViewDelegate>

-(id)initWithURL:(NSString *)urlString frame:(CGRect)frame;

@end
