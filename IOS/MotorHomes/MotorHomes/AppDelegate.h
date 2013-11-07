//
//  AppDelegate.h
//  MotorHomes
//
//  Created by admin on 07.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class MFSideMenuContainerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) MFSideMenuContainerViewController *menuController;

@end
