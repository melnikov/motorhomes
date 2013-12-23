//
//  FaqController.h
//  MotorHomes
//
//  Created by admin on 03.12.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TapToShowView.h"

enum FaqType
{
	FaqTypeGeneral     = 0,
	FaqTypeService     = 1,
	FaqTypeRemodel     = 2,
	FaqTypeParts       = 3,
	FaqTypeConsignment = 4
};

@interface FaqController : BaseViewController <TapToShowViewDelegate>

-(id)initWithType:(int)_type;

@end
