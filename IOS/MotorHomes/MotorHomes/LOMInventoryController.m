//
//  LOMInventoryController.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "LOMInventoryController.h"
#import "LOMCell.h"

@interface LOMInventoryController ()
{
	NSArray * inventories;
	IBOutlet UIButton *allButton;
	IBOutlet UIButton *byMakeButton;
	IBOutlet UIButton *featuredButton;
}

@end

@implementation LOMInventoryController

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
	
	self.title = @"INVENTORY";
	
	self.rightNavButtonImage = [UIImage imageNamed:@"filterButton"];
	
	inventories = @[@{@"image" : [UIImage imageNamed:@"busPrototype"], @"logoImage" : [UIImage imageNamed:@"logoPrototype"]},
				    @{@"image" : [UIImage imageNamed:@"busPrototype"], @"logoImage" : [UIImage imageNamed:@"logoPrototype"]},
				    @{@"image" : [UIImage imageNamed:@"busPrototype"], @"logoImage" : [UIImage imageNamed:@"logoPrototype"]}];
}

- (void)rightNavButtonPressed
{
	ALog(@"Filter pressed");
}

- (IBAction)segmentChanged:(UIButton *)sender {
	allButton.selected = (sender == allButton);
	byMakeButton.selected = (sender == byMakeButton);
	featuredButton.selected = (sender == featuredButton);
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
    LOMCell *cell = (LOMCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		//если ячейка не найдена - создаем новую
		cell = [[[NSBundle mainBundle] loadNibNamed:@"LOMCell"owner:self options:nil] objectAtIndex:0];
    }
	
	NSDictionary* dict = inventories[indexPath.row];
	
	cell.itemImageView.image = [dict valueForKey:@"image"];
	cell.logoImageView.image = [dict valueForKey:@"logoImage"];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (void)viewDidUnload {
	allButton = nil;
	byMakeButton = nil;
	featuredButton = nil;
	[super viewDidUnload];
}
@end
