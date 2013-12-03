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
	IBOutlet UITableView *tableFilteredIpad;
	NSArray * inventoriesByMake;
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
	
	BOOL isByMakeData;
	
	AFHTTPClient *httpClient;
}

@end

@implementation LOMInventoryController

-(void)createHttpClient
{
	if(!httpClient)
	{
		httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://mot-stage.herokuapp.com/"]];
		[httpClient setAllowsInvalidSSLCertificate:YES];
	}
}

-(void)getInventories
{
	[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
	
	[self createHttpClient];
	
	[self segmentChanged:allButton];
	[self filterChanged:filterAllButton];
	
	[[httpClient operationQueue] cancelAllOperations];
	
	[self getListOfInventoriesFeatured:NO offset:0 count:1000];
	[self getListOfInventoriesByMake];
	;
}

-(void)hideHUD
{
	if([[httpClient operationQueue] operationCount] == 0)
	{
		[MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

-(void)getListOfInventoriesFeatured:(BOOL)featured offset:(int)offset count:(int)count
{
	isByMakeData = NO;
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSString * path = [NSString stringWithFormat:@"client/inventory_selections.json?is_featured=%@&amount=%d&offset=%d", (featured ? @"yes" : @"no"), count, offset];
	
	[httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		if ([operation isCancelled]) return;
		//NSLog(@"%@", [responseObject JSONValue]);
		inventoriesFiltered = [responseObject JSONValue];
		if(!IS_IPAD)
		{
			//[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
			
			[table reloadData];
		}
		else
		{
			//[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
			
			[tableFilteredIpad reloadData];
		}
		[self hideHUD];
	}
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		NSLog(@"Error: %@", error);
		[self hideHUD];
	}];
}

-(void)getListOfInventoriesByMake
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSString * path = [NSString stringWithFormat:@"front/vehicles/makes/all.json"];
	
	[httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		if ([operation isCancelled]) return;
		//NSLog(@"%@", [responseObject JSONValue]);
		inventoriesByMake = [responseObject JSONValue];
		//[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		[table reloadData];
		[self hideHUD];
	}
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		NSLog(@"Error: %@", error);
		[self hideHUD];
	}];
}

-(void)getListOfInventoriesModeldByMakeName:(NSString*)makeName
{
	if(IS_IPAD)
	{
		isByMakeData = YES;
		
		allButton.selected = NO;
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSString * path = [NSString stringWithFormat:@"front/vehicles/models/%@/all.json", makeName];
	
	[httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if ([operation isCancelled]) return;
		 NSArray * models = [responseObject JSONValue];
		 
		 if(models.count <= 0)
			[self hideHUD];
		 
		 NSMutableArray * inventoriesByMakeName = [NSMutableArray new];
		 
		 for (int i = 0; i < models.count; i++)
		 {
			 NSString * modelName = [models[i] valueForKey:@"name"];
			 
			 NSString * path = [NSString stringWithFormat:@"front/vehicles/inventory/%@/%@/all.json", makeName, modelName];
			 
			 [httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
			 {
				 if ([operation isCancelled]) return;
				 
				 [inventoriesByMakeName addObjectsFromArray:[responseObject JSONValue]];
				 
				 if(i == models.count - 1)
				 {
					 [self hideHUD];
					 
					 if(IS_IPAD)
					 {
						 inventoriesFiltered = inventoriesByMakeName;
						 
						 //[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
						 
						 [tableFilteredIpad reloadData];
						 
						 [self hideHUD];
					 }
					 else
					 {
						 [self.navigationController pushViewController:[[LOIInventoryController alloc] initWithInventories:inventoriesByMakeName] animated:YES];
					 }
				 }
			 }
			 failure:^(AFHTTPRequestOperation *operation, NSError *error)
			 {
				  NSLog(@"Error: %@", error);
				  [self hideHUD];
				 
				 inventoriesFiltered = [NSArray new];
				 
				 //[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
				 
				 [tableFilteredIpad reloadData];
			 }];
		 }
	 }
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
		 NSLog(@"Error: %@", error);
		 [self hideHUD];
		 
		 inventoriesFiltered = [NSArray new];
		 
		 //[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		 
		  [tableFilteredIpad reloadData];
	 }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"INVENTORY";
	
	self.rightNavButtonImage = [UIImage imageNamed:@"filterButton"];
	
	isByMakeData = NO;
	
	[self getInventories];
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
		[UIView animateWithDuration:0.15 animations:^{
			filterView.frame = CGRectMake(filterView.frame.origin.x, filterView.frame.origin.y, filterView.frame.size.width, 200);
		} completion:^(BOOL finished) {
			filterView.frame = CGRectMake(filterView.frame.origin.x, filterView.frame.origin.y, filterView.frame.size.width, 1000);
		}];
	else
	{
		filterView.frame = CGRectMake(filterView.frame.origin.x, filterView.frame.origin.y, filterView.frame.size.width, 200);
		
		[UIView animateWithDuration:0.15 animations:^{
			filterView.frame = CGRectMake(filterView.frame.origin.x, filterView.frame.origin.y, filterView.frame.size.width, 0);
		}];
	}
}

- (IBAction)closeFilterPressed
{
	[self rightNavButtonPressed];
}

-(void)showFeatured
{
	[self segmentChanged:featuredButton];
}

- (IBAction)segmentChanged:(UIButton *)sender
{
	if(segmentType != sender.tag || !sender.selected)
	{
		allButton.selected = (sender == allButton);
		byMakeButton.selected = (sender == byMakeButton);
		featuredButton.selected = (sender == featuredButton);
		
		segmentType = sender.tag;
		
		if([inventoriesByMake count] && [inventoriesFiltered count])
			[[httpClient operationQueue] cancelAllOperations];
		
		//Show/hide right navigation button
		if(segmentType == segmentByMake)
		{
			[self.navigationController.navigationBar viewWithTag:20].hidden = YES;
			
			//[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
			
			[table reloadData];
		}
		else
		{
			[tableFilteredIpad deselectRowAtIndexPath:[tableFilteredIpad indexPathForSelectedRow] animated:YES];
			
			[self.navigationController.navigationBar viewWithTag:20].hidden = NO;
			
			[self getListOfInventoriesFeatured:segmentType offset:0 count:5];
		}
	}
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
		
		if(filterView.frame.size.height != 0)
			[self rightNavButtonPressed];
		
//		if(!IS_IPAD)
//		{
//			[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//			[table reloadData];
//		
//		}
//		else
//		{
//			[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//			[tableFilteredIpad reloadData];
//
//	    }
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(segmentType == segmentByMake || (IS_IPAD && tableView == table))
		return inventoriesByMake.count;
	
	return inventoriesFiltered.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(!IS_IPAD)
	{
		if(segmentType == segmentByMake)
			return 145;
	}
	else
	{
		if(tableView == table)
			return 145;
		else
			return 330;
	}
	
	return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(segmentType == segmentByMake || (IS_IPAD && tableView == table))
	{
		static NSString *CellIdentifier = @"CellLOM";
		
		//поиск ячейки
		LOMCell *cell = (LOMCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			//если ячейка не найдена - создаем новую
			cell = [[[NSBundle mainBundle] loadNibNamed:@"LOMCell"owner:self options:nil] objectAtIndex:0];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			if(IS_IPAD)
				cell.selectionStyle = UITableViewCellSelectionStyleGray;
		}
		
		NSDictionary* dict = inventoriesByMake[indexPath.row];
		
		//cell.itemImageView.image = [dict valueForKey:@"image"];
		cell.logoImageView.image = [dict valueForKey:@"logoImage"];
		cell.nameLabel.text = [dict valueForKey:@"name"];
		
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
		
		if(!isByMakeData)
		{
			NSDictionary* dict = inventoriesFiltered[indexPath.row];
			
			NSString * imageUrl = [dict valueForKeyPath:@"vehicle.client_list_image"];
			if(imageUrl)
				[cell.itemImage setImageWithURL:[NSURL URLWithString:imageUrl]];
			
			cell.nameLabel.text = [dict valueForKeyPath:@"vehicle.full_name"];
			
			NSString * price = [@"$" stringByAppendingString:[dict valueForKeyPath:@"vehicle.final_price"]];
			if(price)
				[cell.priceButton setTitle:price forState:UIControlStateNormal];
		}
		else
		{
			NSDictionary* dict = inventoriesFiltered[indexPath.row];
			
			NSString * imageUrl = [dict valueForKeyPath:@"view_thumb_image"];
			if(imageUrl)
				[cell.itemImage setImageWithURL:[NSURL URLWithString:imageUrl]];
			
			cell.nameLabel.text = [dict valueForKeyPath:@"full_name"];
			
			NSString * price = [NSString stringWithFormat:@"$%d", [[dict valueForKey:@"price"] intValue]];
			if(price)
				[cell.priceButton setTitle:price forState:UIControlStateNormal];
		}
		
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(!IS_IPAD)
	{
		if(segmentType == segmentByMake)
		{
			[[httpClient operationQueue] cancelAllOperations];
			
			NSString * name = [inventoriesByMake[indexPath.row] valueForKey:@"url_name"];
			
			[self getListOfInventoriesModeldByMakeName:name];
		}
		else
			[self.navigationController pushViewController:[[ItemDetailsController alloc] initWithInventory:inventoriesFiltered[indexPath.row]] animated:YES];
	}
	else
	{
		if(tableView == tableFilteredIpad)
		{
			[self.navigationController pushViewController:[[ItemDetailsController alloc] initWithInventory:inventoriesFiltered[indexPath.row]] animated:YES];
		}
		else
		{
			[[httpClient operationQueue] cancelAllOperations];
			
			NSString * name = [inventoriesByMake[indexPath.row] valueForKey:@"url_name"];
			
			[self getListOfInventoriesModeldByMakeName:name];
		}
	}
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
	tableFilteredIpad = nil;
	[super viewDidUnload];
}
@end
