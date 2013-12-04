//
//  ItemDetailsController.m
//  MotorHomes
//
//  Created by admin on 12.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "ItemDetailsController.h"
#import "GalleryController.h"

@interface ItemDetailsController ()
{
	IBOutlet UIButton *generalButton;
	IBOutlet UIButton *specsButton;
	IBOutlet UIButton *eqipmentButton;
	IBOutlet UIImageView *oldPriceBack;
	IBOutlet UILabel *oldPrice;
	IBOutlet UILabel *newPrice;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *headerLabel;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UIScrollView *scroll;
	IBOutlet UIImageView *imageView;
	IBOutlet UIButton *videoButton;
	IBOutlet UIButton *zoomButton;
	
	NSDictionary* inventory;
	
	AFHTTPClient * httpClient;
	
	NSArray * vechicleImages;
	NSArray * vechicleOptions;
	
	IBOutlet UITextView *textView;
}

@end

@implementation ItemDetailsController

-(id)initWithInventory:(NSDictionary*)_inventory
{
	self = [super init];
    if (self) {
        // Custom initialization
		inventory = _inventory;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"DETAILS";
	
	self.rightNavButtonImage = [UIImage imageNamed:@"heartButton"];
	
	[self setupContent];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self getSpecsForInventory];
}

-(void)getSpecsForInventory
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:API_URL_STRING]];
	[httpClient setAllowsInvalidSSLCertificate:YES];
	
	int vechicleID = [[inventory valueForKey:@"id"] intValue];
	
	if([inventory objectForKey:@"vehicle"])
	{
		[self parseSpecs:inventory];
		
		return;
	}
	
	NSString * path = [NSString stringWithFormat:@"client/inventory_selections/%d/vehicle_details.json", vechicleID];
	
	[httpClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
	 {
		 if ([operation isCancelled]) return;
		 
		 NSDictionary * specs = [responseObject JSONValue];
		 
		 NSMutableArray * images = [[specs valueForKeyPath:@"vehicle.vehicle_images"] mutableCopy];
		 
		 for (int i = 0; i < images.count; i++)
		 {
			 [images replaceObjectAtIndex:i withObject:[images[i] valueForKeyPath:@"vehicle_image.client_view_image"]];
		 }
		 
		 if(images.count > 0)
		 {
			 zoomButton.enabled = YES;
			 
			 vechicleImages = images;
		 }
		 
		 NSMutableArray * optionsCategories = [[specs valueForKeyPath:@"vehicle.vehicle_option_categories"] mutableCopy];
		 
		 NSArray * options = [specs valueForKeyPath:@"vehicle.vehicle_options"];
		 
		 NSString * optionsText = @"";
		 
		 for (int i = 0; i < optionsCategories.count; i++)
		 {
			 optionsText = [optionsText stringByAppendingFormat:@"\n%@\n", [[optionsCategories[i] valueForKeyPath:@"vehicle_option_category.name"] uppercaseString]];
			 
			 int categoryID = [[optionsCategories[i] valueForKeyPath:@"vehicle_option_category.id"] intValue];
			 
			 NSMutableArray * optionsInCategory = [NSMutableArray new];
			 
			 int z = 0;
			 
			 for (int j = 0; j < options.count; j++)
			 {
				 NSDictionary * option = options[j];
				 
				 if([[option valueForKeyPath:@"vehicle_option.vehicle_option_category_id"] intValue] == categoryID)
				 {
					 [optionsInCategory addObject:[option valueForKey:@"vehicle_option"]];
					 
					 z++;
					 
					 optionsText = [optionsText stringByAppendingFormat:@"%2d) %@\n", z, [option valueForKeyPath:@"vehicle_option.name"]];
				 }
			 }
			 
			 NSMutableDictionary * newCategory = [[optionsCategories[i] valueForKey:@"vehicle_option_category"] mutableCopy];
			 
			 [newCategory setObject:optionsInCategory forKey:@"options"];
			 
			 [optionsCategories replaceObjectAtIndex:i withObject:newCategory];
		 }
		 
		 if(optionsCategories.count)
		 {
			 vechicleOptions = optionsCategories;
			 
			 textView.text = optionsText;
		 }
		 
		 [self hideHUD];
	 }
	failure:^(AFHTTPRequestOperation *operation, NSError *error)
	 {
		 NSLog(@"Error: %@", error);
		 [self hideHUD];
	 }];
}

-(void)parseSpecs:(NSDictionary*)specs
{
	NSMutableArray * images = [[specs valueForKeyPath:@"vehicle.vehicle_images"] mutableCopy];
	
	for (int i = 0; i < images.count; i++)
	{
		[images replaceObjectAtIndex:i withObject:[images[i] valueForKeyPath:@"vehicle_image.client_view_image"]];
	}
	
	if(images.count > 0)
	{
		zoomButton.enabled = YES;
		
		vechicleImages = images;
	}
	
	NSMutableArray * optionsCategories = [[specs valueForKeyPath:@"vehicle.vehicle_option_categories"] mutableCopy];
	
	NSArray * options = [specs valueForKeyPath:@"vehicle.vehicle_options"];
	
	NSString * optionsText = @"";
	
	for (int i = 0; i < optionsCategories.count; i++)
	{
		optionsText = [optionsText stringByAppendingFormat:@"\n%@\n", [[optionsCategories[i] valueForKeyPath:@"vehicle_option_category.name"] uppercaseString]];
		
		int categoryID = [[optionsCategories[i] valueForKeyPath:@"vehicle_option_category.id"] intValue];
		
		NSMutableArray * optionsInCategory = [NSMutableArray new];
		
		int z = 0;
		
		for (int j = 0; j < options.count; j++)
		{
			NSDictionary * option = options[j];
			
			if([[option valueForKeyPath:@"vehicle_option.vehicle_option_category_id"] intValue] == categoryID)
			{
				[optionsInCategory addObject:[option valueForKey:@"vehicle_option"]];
				
				z++;
				
				optionsText = [optionsText stringByAppendingFormat:@"%2d) %@\n", z, [option valueForKeyPath:@"vehicle_option.name"]];
			}
		}
		
		NSMutableDictionary * newCategory = [[optionsCategories[i] valueForKey:@"vehicle_option_category"] mutableCopy];
		
		[newCategory setObject:optionsInCategory forKey:@"options"];
		
		[optionsCategories replaceObjectAtIndex:i withObject:newCategory];
	}
	
	if(optionsCategories.count)
	{
		vechicleOptions = optionsCategories;
		
		textView.text = optionsText;
	}
}

-(void)hideHUD
{
	if([[httpClient operationQueue] operationCount] == 0)
	{
		[MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

-(void)setupContent
{
	if(![inventory objectForKey:@"vehicle"])
	{
		nameLabel.text = [inventory valueForKey:@"full_name"];
		headerLabel.text = [inventory valueForKey:@"description"];
		descriptionLabel.text = [inventory valueForKey:@"brochure_text"];
		
		NSString * price;
		if([inventory valueForKey:@"final_price"] != [NSNull null])
			price = [NSString stringWithFormat:@"$%@", [inventory valueForKey:@"final_price"]];
		if(price)
			newPrice.text = price;
		
		NSString * imageUrl = [inventory valueForKeyPath:@"view_thumb_image"];
		if(imageUrl)
			[imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
	}
	else
	{
		nameLabel.text = [inventory valueForKeyPath:@"vehicle.full_name"];
		headerLabel.text = [inventory valueForKeyPath:@"vehicle.description"];
		descriptionLabel.text = [inventory valueForKeyPath:@"vehicle.features"];
		
		NSString * price;
		if([inventory valueForKey:@"vehicle.final_price"] != [NSNull null])
			price = [NSString stringWithFormat:@"$%@", [inventory valueForKeyPath:@"vehicle.final_price"]];
		if(price)
			newPrice.text = price;
		
		NSString * imageUrl = [inventory valueForKeyPath:@"vehicle.client_view_image"];
		if(imageUrl)
			[imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
	}
	
	oldPriceBack.hidden = YES;
	oldPrice.hidden = YES;
	videoButton.enabled = NO;
	zoomButton.enabled = NO;
	
	//[inventory valueForKey:@"reduced_price"];
	//[inventory valueForKey:@"VIDEO"];
	
	CGRect rect = descriptionLabel.frame;
	
	CGSize size = [descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(rect.size.width, 9999) lineBreakMode:descriptionLabel.lineBreakMode];
	
	rect.size = size;
	descriptionLabel.frame = rect;
	
	scroll.contentSize = CGSizeMake(scroll.contentSize.width, rect.origin.y + rect.size.height);
}

- (IBAction)segmentChanged:(UIButton *)sender {
	generalButton.selected = (sender == generalButton);
	specsButton.selected = (sender == specsButton);
	eqipmentButton.selected = (sender == eqipmentButton);
	
	scroll.hidden = !generalButton.isSelected;
	textView.hidden = !eqipmentButton.isSelected;
}

- (IBAction)zoomToolPressed
{
	[self.navigationController pushViewController:[[GalleryController alloc] initWithImages:vechicleImages] animated:YES];
}

- (IBAction)watchVideoPressed
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=qJXGor0FCcc#t=0"]];
}

- (IBAction)callUsPressed
{
	NSString *phone = @"1-800-651-1112";
	
	[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Call %@?", phone] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		NSString *phone = @"tel://18006511112";
		
		ALog(@"Dialing %@", phone);
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
	}
}

- (IBAction)emailUsPressed
{
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	NSArray *adress=[NSArray arrayWithObject:@"support@motorhomesoftexas.com"];
	[controller setToRecipients:adress];
	[controller setSubject:@"Subject"];
	
//	NSDateFormatter* df = [[NSDateFormatter alloc]init];
//	[df setDateFormat:@"dd-MMM-yy"];
//	
//	[controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@_%@.pdf",
//																				[[report objectForKey:@"keyInformation"] objectForKey:@"name"],
//																				[df stringFromDate:[NSDate date]]]];
	[controller setMessageBody:@"Message Body" isHTML:NO];
	if (controller) [self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        ALog(@"letter send");
		[[[UIAlertView alloc] initWithTitle:nil message:@"Email successfully sent"
													   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)rightNavButtonPressed
{
	ALog(@"Heart pressed");
}

- (void)viewDidUnload {
	generalButton = nil;
	specsButton = nil;
	eqipmentButton = nil;
	oldPrice = nil;
	newPrice = nil;
	nameLabel = nil;
	headerLabel = nil;
	descriptionLabel = nil;
	scroll = nil;
	imageView = nil;
	videoButton = nil;
	zoomButton = nil;
	textView = nil;
	[super viewDidUnload];
}
@end
