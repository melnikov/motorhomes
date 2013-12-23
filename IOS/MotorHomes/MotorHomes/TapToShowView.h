//
//  TapToShowView.h
//  MotorHomes
//
//  Created by admin on 04.12.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TapToShowView;

@protocol TapToShowViewDelegate

@optional
-(void)tapToShowView:(TapToShowView*)view heightChanged:(float)height;

@end

@interface TapToShowView : UIView

@property (strong, nonatomic) IBOutlet UILabel *headerText;
@property (strong, nonatomic) IBOutlet UILabel *contentText;
@property (strong, nonatomic) NSObject <TapToShowViewDelegate> * delegate;

@end