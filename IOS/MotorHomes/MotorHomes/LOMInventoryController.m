//
//  LOMInventoryController.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "LOMInventoryController.h"
#import "LOMCell.h"
#import "LOICell.h"

#import "LOIInventoryController.h"
#import "ItemDetailsController.h"

enum segmentType
{
	segmentAll = 0,
	segmentByMake = 1,
	segmentFeatured = 2
};

enum filterType
{
	filterNewest = 0,
	filterReduced = 1,
	filterForetravel = 2,
	filterCountry = 3,
	filterNewell = 4,
	filterAll = 5
};

@interface LOMInventoryController ()
{
	IBOutlet UITableView *table;
	NSArray * inventories;
	NSArray * inventoriesFiltered;
	int segmentType;
	IBOutlet UIButton *allButton;
	IBOutlet UIButton *byMakeButton;
	IBOutlet UIButton *featuredButton;
	int filterType;
	IBOutlet UIView   *filterView;
	IBOutlet UIButton *filterAllButton;
	IBOutlet UIButton *filterNewellButton;
	IBOutlet UIButton *filterCountryButton;
	IBOutlet UIButton *filterForetravelButton;
	IBOutlet UIButton *filterReducedPriceButton;
	IBOutlet UIButton *filterNewestButton;
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
	
	segmentType = segmentByMake;
	filterType = filterAll;
	
	inventories = @[@{@"image" : [UIImage imageNamed:@"busPrototype"], @"logoImage" : [UIImage imageNamed:@"logoPrototype"]},
				    @{@"image" : [UIImage imageNamed:@"busPrototype"], @"logoImage" : [UIImage imageNamed:@"logoPrototype"]},
				    @{@"image" : [UIImage imageNamed:@"busPrototype"], @"logoImage" : [UIImage imageNamed:@"logoPrototype"]}];
	
	inventoriesFiltered = @[@{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"},
						    @{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"},
						    @{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"}];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//Hide right navigation button
	if(segmentType == segmentByMake)
		[self.navigationController.navigationBar viewWithTag:20].hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	//Show right navigation button
	[self.navigationController.navigationBar viewWithTag:20].hidden = NO;
}

- (void)rightNavButtonPressed
{
	if(filterView.frame.size.height == 0)
		[UIView animateWithDuration:0.2 animations:^{
			filterView.frame = CGRectMake(filterView.frame.origin.x, filterView.frame.origin.y, filterView.frame.size.width, 504);
		}];
	else
		[UIView animateWithDuration:0.2 animations:^{
			filterView.frame = CGRectMake(filterView.frame.origin.x, filterView.frame.origin.y, filterView.frame.size.width, 0);
		}];
}

- (IBAction)closeFilterPressed {
	[self rightNavButtonPressed];
}

- (IBAction)segmentChanged:(UIButton *)sender {
	allButton.selected = (sender == allButton);
	byMakeButton.selected = (sender == byMakeButton);
	featuredButton.selected = (sender == featuredButton);
	
	if(segmentType != sender.tag)
	{
		segmentType = sender.tag;
		
		[table reloadData];
	}
	
	//Show/hide right navigation button
	if(segmentType == segmentByMake)
		[self.navigationController.navigationBar viewWithTag:20].hidden = YES;
	else
		[self.navigationController.navigationBar viewWithTag:20].hidden = NO;
}

- (IBAction)filterChanged:(UIButton *)sender
{
	filterNewestButton.selected = (sender == filterNewestButton);
	filterReducedPriceButton.selected = (sender == filterReducedPriceButton);
	filterForetravelButton.selected = (sender == filterForetravelButton);
	filterCountryButton.selected = (sender == filterCountryButton);
	filterNewellButton.selected = (sender == filterNewellButton);
	filterAllButton.selected = (sender == filterAllButton);
	
	if(filterType != sender.tag)
	{
		filterType = sender.tag;
		
		[self rightNavButtonPressed];
		
		//[table reloadData];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(segmentType == segmentByMake)
		return inventories.count;
	
	return inventoriesFiltered.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(segmentType == segmentByMake)
		return 145;
	
	return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(segmentType == segmentByMake)
	{
		static NSString *CellIdentifier = @"CellLOM";
		
		//поиск ячейки
		LOMCell *cell = (LOMCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			//если ячейка не найдена - создаем новую
			cell = [[[NSBundle mainBundle] loadNibNamed:@"LOMCell"owner:self options:nil] objectAtIndex:0];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		NSDictionary* dict = inventories[indexPath.row];
		
		cell.itemImageView.image = [dict valueForKey:@"image"];
		cell.logoImageView.image = [dict valueForKey:@"logoImage"];
		
		return cell;
	}
	else
	{
		static NSString *CellIdentifier = @"CellLOI";
		
		//поиск ячейки
		LOICell *cell = (LOICell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			//если ячейка не найдена - создаем новую
			cell = [[[NSBundle mainBundle] loadNibNamed:@"LOICell"owner:self options:nil] objectAtIndex:0];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		NSDictionary* dict = inventoriesFiltered[indexPath.row];
		
		cell.itemImage.image = [dict valueForKey:@"image"];
		cell.nameLabel.text = [dict valueForKey:@"name"];
		[cell.priceButton setTitle:[dict valueForKey:@"price"] forState:UIControlStateNormal];
		
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(segmentType == segmentByMake)
		[self.navigationController pushViewController:[LOIInventoryController new] animated:YES];
	else
		[self.navigationController pushViewController:[ItemDetailsController new] animated:YES];
}

- (void)viewDidUnload {
	allButton = nil;
	byMakeButton = nil;
	featuredButton = nil;
	table = nil;
	filterView = nil;
	filterNewestButton = nil;
	filterReducedPriceButton = nil;
	filterForetravelButton = nil;
	filterCountryButton = nil;
	filterNewellButton = nil;
	filterAllButton = nil;
	[super viewDidUnload];
}
@end
