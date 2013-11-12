//
//  ItemDetailsController.m
//  MotorHomes
//
//  Created by admin on 12.11.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "ItemDetailsController.h"

@interface ItemDetailsController ()
{
	IBOutlet UIButton *generalButton;
	IBOutlet UIButton *specsButton;
	IBOutlet UIButton *eqipmentButton;
	IBOutlet UILabel *oldPrice;
	IBOutlet UILabel *newPrice;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *headerLabel;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UIScrollView *scroll;
}

@end

@implementation ItemDetailsController

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
	
	self.title = @"DETAILS";
	
	self.rightNavButtonImage = [UIImage imageNamed:@"heartButton"];
	
	[self setupContent];
}

-(void)setupContent
{
	nameLabel.text = @"2000 COUNTRY COACH INTRIGUE  36' (#P1126A)";
	headerLabel.text = @"Very Nice & Clean 36' Slide";
	descriptionLabel.text = @"WOW is the first thing you think of when you step inside this barely used Country Coach Intrigue. You may just think you are looking at a new 2000 coach. Nice and clean to the extreme and beautifully maintained. Like new lite gray leather front seats and living room recliner with a convertible booth type dinette and fabric jack-knife sofa leading to a tile kitchen and bath floor. Corian kitchen and bath counter tops impart the well deserved look and feel of luxury.";
	
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
}

- (IBAction)zoomToolPressed
{
	ALog(@"Zoom pressed");
}

- (IBAction)watchVideoPressed
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=qJXGor0FCcc#t=0"]];
}

- (IBAction)callUsPressed
{
	NSString *phone = @"+7(012)345-67-89";
	
	[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Call %@?", phone] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		NSString *phone = @"+7(012)345-67-89";
		
		phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
		phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
		phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
		phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
		phone = [NSString stringWithFormat:@"tel://%@", phone];
		
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
	[super viewDidUnload];
}
@end
