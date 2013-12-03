//
//  LOIInventoryController.h
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "BaseViewController.h"

@interface LOIInventoryController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

-(id)initWithInventories:(NSArray*)_inventories;

@end
