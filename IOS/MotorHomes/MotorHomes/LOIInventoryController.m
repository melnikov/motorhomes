//
//  LOIInventoryController.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "LOIInventoryController.h"
#import "LOICell.h"

@interface LOIInventoryController ()
{
	NSArray * inventories;
}

@end

@implementation LOIInventoryController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"MOTORHOMES";
	
	self.rightNavButtonImage = [UIImage imageNamed:@"filterButton"];
	
	inventories = @[@{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"},
				 @{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"},
				 @{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"}];
}

- (void)rightNavButtonPressed
{
	ALog(@"Filter pressed");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return inventories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    
    //поиск ячейки
    LOICell *cell = (LOICell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//если ячейка не найдена - создаем новую
		cell = [[[NSBundle mainBundle] loadNibNamed:@"LOICell"owner:self options:nil] objectAtIndex:0];
    }
	
	NSDictionary* dict = inventories[indexPath.row];
	
	cell.itemImage.image = [dict valueForKey:@"image"];
	cell.nameLabel.text = [dict valueForKey:@"name"];
	[cell.priceButton setTitle:[dict valueForKey:@"price"] forState:UIControlStateNormal];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

@end
