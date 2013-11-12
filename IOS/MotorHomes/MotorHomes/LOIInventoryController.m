//
//  LOIInventoryController.m
//  MotorHomes
//
//  Created by admin on 11.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "LOIInventoryController.h"
#import "LOICell.h"

#import "ItemDetailsController.h"

enum filterType
{
	filterNewest = 0,
	filterReduced = 1,
	filterForetravel = 2,
	filterCountry = 3,
	filterNewell = 4,
	filterAll = 5
};

@interface LOIInventoryController ()
{
	NSArray * inventories;
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
	
	filterType = filterAll;
	
	inventories = @[@{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"},
				 @{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"},
				 @{@"image" : [UIImage imageNamed:@"busPrototype2"], @"name" : @"2002 FORETRAVEL U320 42'", @"price" : @"$219,500"}];
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	NSDictionary* dict = inventories[indexPath.row];
	
	cell.itemImage.image = [dict valueForKey:@"image"];
	cell.nameLabel.text = [dict valueForKey:@"name"];
	[cell.priceButton setTitle:[dict valueForKey:@"price"] forState:UIControlStateNormal];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.navigationController pushViewController:[ItemDetailsController new] animated:YES];
}

@end
