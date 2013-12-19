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

#define COUNT 100

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
	NSArray * inventoriesBySelectedMake;
	NSArray * inventoriesAll;
	NSArray * inventoriesFeatured;
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
		httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:API_URL_STRING]];
		[httpClient setAllowsInvalidSSLCertificate:YES];
	}
}

-(void)getInventories
{
	[self createHttpClient];
	
	[self segmentChanged:byMakeButton];
	[self filterChanged:filterAllButton];
}

-(void)hideHUD
{
//	if([[httpClient operationQueue] operationCount] == 0)
//	{
		[MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//	}
}

-(NSData*)getCachedResponseDataWithPath:(NSString*)path httpMethod:(NSString*)httpMethod parameters:(NSDictionary*)parameters
{
	NSMutableURLRequest * request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
	
	NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
	
	if (cachedResponse != nil && [[cachedResponse data] length] > 0)
	{
		id data = [cachedResponse.data JSONValue];
		
		if((![data isKindOfClass:[NSArray class]] && ![data isKindOfClass:[NSDictionary class]]) ||
		   ([data isKindOfClass:[NSArray class]] && [data count] <= 0) || ([data isKindOfClass:[NSDictionary class]] && [data allKeys] <= 0))
			return nil;
		
		// Get cached data
		NSLog(@"Cache loaded for path: %@", path);
		
		return cachedResponse.data;
	}
	
	return nil;
}

-(void)fetchListOfInventoriesResponseData:(id)data segmentType:(int)type
{
	//NSLog(@"%@", [responseObject JSONValue]);
	
	if(type == segmentAll || type == segmentFeatured)
	{
		if(type == segmentFeatured)
			inventoriesFeatured = [data JSONValue];
		else
			inventoriesAll = [data JSONValue];
		
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
	}
	else if(type == segmentByMake)
	{
		inventoriesByMake = [data JSONValue];
		//[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		[table reloadData];
	}
	else
	{
		NSArray * models = [[data objectForKey:@"data"] JSONValue];
		
		NSString * makeName = [data objectForKey:@"makeName"];
		
		if(models.count <= 0)
			[self hideHUD];
		
		NSMutableArray * inventoriesByMakeName = [NSMutableArray new];
		
		for (int i = 0; i < models.count; i++)
		{
			NSString * modelName = [models[i] valueForKey:@"url_name"];
			
			NSString * path = [NSString stringWithFormat:@"front/vehicles/inventory/%@/%@/all.json", makeName, modelName];
			
			NSData * data = [self getCachedResponseDataWithPath:path httpMethod:@"GET" parameters:nil];
			
			if (data != nil && [data length] > 0)
			{
				[inventoriesByMakeName addObjectsFromArray:[data JSONValue]];
				
				if(i == models.count - 1)
				{
					[self hideHUD];
					
					if(IS_IPAD)
					{
						inventoriesBySelectedMake = inventoriesByMakeName;
						
						//[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
						
						[tableFilteredIpad reloadData];
					}
					else
					{
						[self.navigationController pushViewController:[[LOIInventoryController alloc] initWithInventories:inventoriesByMakeName] animated:YES];
					}
				}
				
				continue;
			}
			
			[httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
			 {
				 [inventoriesByMakeName addObjectsFromArray:[responseObject JSONValue]];
				 
				 if(i == models.count - 1)
				 {
					 [self hideHUD];
					 
					 if(IS_IPAD)
					 {
						 inventoriesBySelectedMake = inventoriesByMakeName;
						 
						 //[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
						 
						 [tableFilteredIpad reloadData];
					 }
					 else
					 {
						 [self.navigationController pushViewController:[[LOIInventoryController alloc] initWithInventories:inventoriesByMakeName] animated:YES];
					 }
				 }
			 }
						failure:^(AFHTTPRequestOperation *operation, NSError *error)
			 {
				 [self hideHUD];
				 
				 NSData * data = [self getCachedResponseDataWithPath:path httpMethod:@"GET" parameters:nil];
				 
				 if (data != nil && [data length] > 0)
				 {
					 [inventoriesByMakeName addObjectsFromArray:[data JSONValue]];
					 
					 if(i == models.count - 1)
					 {
						 [self hideHUD];
						 
						 if(IS_IPAD)
						 {
							 inventoriesBySelectedMake = inventoriesByMakeName;
							 
							 //[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
							 
							 [tableFilteredIpad reloadData];
						 }
						 else
						 {
							 [self.navigationController pushViewController:[[LOIInventoryController alloc] initWithInventories:inventoriesByMakeName] animated:YES];
						 }
					 }
				 }
				 else
				 {
					 inventoriesBySelectedMake = [NSArray new];
					 
					 //[tableFilteredIpad scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
					 
					 [tableFilteredIpad reloadData];
				 }
				 
				 NSLog(@"Error: %@", error);
			 }];
		}
	}
	
	[self hideHUD];
}

-(void)getListOfInventoriesFeatured:(BOOL)featured offset:(int)offset count:(int)count
{
	isByMakeData = NO;
	
	int type = (featured ? segmentFeatured : segmentAll);
	
	[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSString * path = [NSString stringWithFormat:@"client/inventory_selections.json?is_featured=%@&amount=%d&offset=%d", (featured ? @"yes" : @"no"), count, offset];
	
	NSData * data = [self getCachedResponseDataWithPath:path httpMethod:@"GET" parameters:nil];
	
	if (data != nil && [data length] > 0)
	{
		[self fetchListOfInventoriesResponseData:data segmentType:type];
		
		return;
	}
	
	[httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		NSLog(@"Inventories Loaded");
		
		[self fetchListOfInventoriesResponseData:responseObject segmentType:type];
	}
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		NSData * data = [self getCachedResponseDataWithPath:path httpMethod:@"GET" parameters:nil];
		
		if (data != nil && [data length] > 0)
		{
			[self fetchListOfInventoriesResponseData:data segmentType:type];
			
			return;
		}
		
		NSLog(@"Error: %@", error);
		
		[self hideHUD];
	}];
}

-(void)getListOfInventoriesByMake
{
	[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSString * path = [NSString stringWithFormat:@"front/vehicles/makes/all.json"];
	
	NSData * data = [self getCachedResponseDataWithPath:path httpMethod:@"GET" parameters:nil];
	
	if (data != nil && [data length] > 0)
	{
		[self fetchListOfInventoriesResponseData:data segmentType:segmentByMake];
		
		return;
	}
	
	[httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	{
		NSLog(@"Inventories ByMake Loaded");
		
		[self fetchListOfInventoriesResponseData:responseObject segmentType:segmentByMake];
	}
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	{
		NSData * data = [self getCachedResponseDataWithPath:path httpMethod:@"GET" parameters:nil];
		
		if (data != nil && [data length] > 0)
		{
			[self fetchListOfInventoriesResponseData:data segmentType:segmentByMake];
			
			return;
		}
		
		NSLog(@"Error: %@", error);
		
		if(inventoriesByMake.count <= 0 && IS_IPAD)
			[self getListOfInventoriesByMake];
		
		[self hideHUD];
	}];
}

-(void)getListOfInventoriesModeldByMakeName:(NSString*)makeName
{
	makeName = [makeName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	if(IS_IPAD)
	{
		isByMakeData = YES;
		
		allButton.selected = NO;
	}
	
	[MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	NSString * path = [NSString stringWithFormat:@"front/vehicles/models/%@/all.json", makeName];
	
	NSData * data = [self getCachedResponseDataWithPath:path httpMethod:@"GET" parameters:nil];
	
	if (data != nil && [data length] > 0)
	{
		NSDictionary * dict = @{@"makeName" : makeName, @"data" : data};
		
		[self fetchListOfInventoriesResponseData:dict segmentType:-1];
		
		return;
	}
	
	[httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 NSDictionary * dict = @{@"makeName" : makeName, @"data" : responseObject};
		 
		 NSLog(@"Inventories ByMakeName Loaded");
		 
		 [self fetchListOfInventoriesResponseData:dict segmentType:-1];
	 }
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
		 NSData * data = [self getCachedResponseDataWithPath:path httpMethod:@"GET" parameters:nil];
		 
		 if (data != nil && [data length] > 0)
		 {
			 NSDictionary * dict = @{@"makeName" : makeName, @"data" : data};
			 
			 [self fetchListOfInventoriesResponseData:dict segmentType:-1];
			 
			 return;
		 }
		 
		 [self hideHUD];
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
		
		//Show/hide right navigation button
		if(segmentType == segmentByMake)
		{
			[self.navigationController.navigationBar viewWithTag:20].hidden = YES;
			
			//[table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
			
			[table reloadData];
		}
		else
		{
			NSIndexPath * indexPath = [tableFilteredIpad indexPathForSelectedRow];
			
			if(indexPath)
				[tableFilteredIpad deselectRowAtIndexPath:indexPath animated:YES];
			
			[self.navigationController.navigationBar viewWithTag:20].hidden = NO;
			
			if(!IS_IPAD)
			{
				[table reloadData];
			}
			else
			{
				[tableFilteredIpad reloadData];
			}
		}
		
		switch (segmentType)
		{
			case segmentAll:
				if([inventoriesAll count] <= 0)
				{
					[self getListOfInventoriesFeatured:NO offset:0 count:COUNT];
					
					return;
				}
				break;
				
			case segmentFeatured:
				if([inventoriesFeatured count] <= 0)
				{
					[self getListOfInventoriesFeatured:YES offset:0 count:COUNT];
					
					return;
				}
				break;
				
			case segmentByMake:
				if([inventoriesByMake count] <= 0)
				{
					[self getListOfInventoriesByMake];
					
					return;
				}
				break;
				
			default:
				return;
				break;
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
	if((segmentType == segmentByMake && !IS_IPAD) || (IS_IPAD && tableView == table))
		return inventoriesByMake.count;
	else if(segmentType == segmentAll)
		return inventoriesAll.count;
	else if(segmentType == segmentFeatured)
		return inventoriesFeatured.count;
	else
		return inventoriesBySelectedMake.count;
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
	if((segmentType == segmentByMake && !IS_IPAD) || (IS_IPAD && tableView == table))
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
		
		NSString * imagePath = [NSString stringWithFormat:@"http://s3.amazonaws.com/mot-production/vehicle_makes/sample_images/%d/original/%@", [[dict valueForKey:@"id"] intValue], [dict valueForKey:@"sample_image_file_name"]];
		
		if(imagePath)
			[cell.itemImageView setImageWithURL:[NSURL URLWithString:imagePath]];
		
		NSString * logoPath = [NSString stringWithFormat:@"http://s3.amazonaws.com/mot-production/vehicle_makes/logos/%d/original/%@", [[dict valueForKey:@"id"] intValue], [dict valueForKey:@"logo_file_name"]];
		
		if(logoPath)
			[cell.logoImageView setImageWithURL:[NSURL URLWithString:logoPath]];
		
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
		
		if(segmentType == segmentAll || segmentType == segmentFeatured)
		{
			NSDictionary* dict;
			
			if(segmentType == segmentFeatured)
				dict = inventoriesFeatured[indexPath.row];
			else if(segmentType == segmentAll)
				dict = inventoriesAll[indexPath.row];
			
			NSString * imageUrl = [dict valueForKeyPath:@"vehicle.client_list_image"];
			if(imageUrl)
				[cell.itemImage setImageWithURL:[NSURL URLWithString:imageUrl]];
			
			cell.nameLabel.text = [dict valueForKeyPath:@"vehicle.full_name"];
			
			NSString * price;
			if([dict valueForKeyPath:@"vehicle.final_price"] != [NSNull null])
				price = [@"$" stringByAppendingString:[dict valueForKeyPath:@"vehicle.final_price"]];
			if(price)
				[cell.priceButton setTitle:price forState:UIControlStateNormal];
		}
		else
		{
			NSDictionary* dict = inventoriesBySelectedMake[indexPath.row];
			
			NSString * imageUrl = [dict valueForKeyPath:@"view_thumb_image"];
			if(imageUrl)
				[cell.itemImage setImageWithURL:[NSURL URLWithString:imageUrl]];
			
			cell.nameLabel.text = [dict valueForKeyPath:@"full_name"];
			
			NSString * price;
			if([dict valueForKey:@"price"] != [NSNull null])
				price = [NSString stringWithFormat:@"$%d", [[dict valueForKey:@"price"] intValue]];
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
		else if(segmentType == segmentFeatured)
			[self.navigationController pushViewController:[[ItemDetailsController alloc] initWithInventory:inventoriesFeatured[indexPath.row]] animated:YES];
		else
			[self.navigationController pushViewController:[[ItemDetailsController alloc] initWithInventory:inventoriesAll[indexPath.row]] animated:YES];
	}
	else
	{
		if(tableView == tableFilteredIpad)
		{
			if(segmentType == segmentFeatured)
				[self.navigationController pushViewController:[[ItemDetailsController alloc] initWithInventory:inventoriesFeatured[indexPath.row]] animated:YES];
			else if(segmentType == segmentAll)
				[self.navigationController pushViewController:[[ItemDetailsController alloc] initWithInventory:inventoriesAll[indexPath.row]] animated:YES];
			else
				[self.navigationController pushViewController:[[ItemDetailsController alloc] initWithInventory:inventoriesBySelectedMake[indexPath.row]] animated:YES];
		}
		else
		{
			segmentType = segmentByMake;
			
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
