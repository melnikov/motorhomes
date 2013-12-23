//
//  FaqController.m
//  MotorHomes
//
//  Created by admin on 03.12.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "FaqController.h"

@interface FaqController ()
{
	int type;
	
	IBOutlet UIScrollView *scroll;
	TapToShowView * faq1View;
	TapToShowView * faq2View;
	TapToShowView * faq3View;
	TapToShowView * faq4View;
	
	NSArray * faqViews;
}

@end

@implementation FaqController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithType:(int)_type
{
	self = [super init];
    if (self) {
        // Custom initialization
		type = _type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	faq1View = [[NSBundle mainBundle] loadNibNamed:@"TapToShowView" owner:self options:nil][0];
	faq2View = [[NSBundle mainBundle] loadNibNamed:@"TapToShowView" owner:self options:nil][0];
	faq3View = [[NSBundle mainBundle] loadNibNamed:@"TapToShowView" owner:self options:nil][0];
	faq4View = [[NSBundle mainBundle] loadNibNamed:@"TapToShowView" owner:self options:nil][0];
	
	faq1View.delegate = self;
	faq2View.delegate = self;
	faq3View.delegate = self;
	faq4View.delegate = self;
	
	switch (type)
	{
		case FaqTypeGeneral:
			self.title = @"FAQ";
			
			faq1View.headerText.text = @"Where are you located?";
			faq1View.contentText.text = @"Q: Where are you located?\n\nA: In East Texas, in the small city of Nacogdoches (Nac-o-doe-shus).  It’s about three hours north of Houston, and four hours south of Dallas.  We’re also only a short 50 miles directly west of the Texas-Louisiana border.";
			
			faq2View.headerText.text = @"Is Motorhomes of Texas ever open on a Saturday?";
			faq2View.contentText.text = @"Q: Is Motorhomes of Texas ever open on a Saturday?\n\nA: Though we are officially closed on the weekends, if a person calls in advance and requests a Saturday appointment, we can have a salesperson available to meet here at the business.  Service work, however, is always closed on the weekend.";
			
			faq3View.headerText.text = @"Does Motorhomes of Texas offer financing for purchasing a motorhome?";
			faq3View.contentText.text = @"Q: Does Motorhomes of Texas offer financing for purchasing a motorhome?\n\nA: Yes! About 80% of all our sold motorhomes are financed*, and we also offer a vast array of financing options.  But, as with most things, financing does depend on the individual’s credit score.";
			
			faq4View.headerText.text = @"I live out of state and want to do business with Motorhomes of Texas, but I can’t take the time to travel there.  Do you have drivers to pick up or deliver motorhomes to me?";
			faq4View.contentText.text = @"Q: I live out of state and want to do business with Motorhomes of Texas, but I can’t take the time to travel there.  Do you have drivers to pick up or deliver motorhomes to me?\n\nA: Yes we do!  We try to accommodate all of our customers to ensure an easy and effortless transaction in every way possible.  We have drivers who are generally available to come directly to you to pick up or deliver your motorhome!";
			break;
			
		case FaqTypeService:
			self.title = @"SERVICE CENTER";
			
			faq1View.headerText.text = @"What makes and models of coaches do you service?";
			faq1View.contentText.text = @"Q: What makes and models of coaches do you service?\n\nA: We service ALL makes and models of class A, B, and C motorhomes!";
			
			faq2View.headerText.text = @"How do I set up an appointment to bring my coach in for service?";
			faq2View.contentText.text = @"Q: How do I set up an appointment to bring my coach in for service?\n\nA: Easy! You can email or call us directly to set up an appointment. But please be aware that we may be limited to certain days and times when we can get your coach in for service.  We will try to get you as close to your desired day and time as possible though so just get in touch with us!";
			
			faq3View.headerText.text = @"What are your service warranties?";
			faq3View.contentText.text = @"Q: What are your service warranties?\n\nA: We do provide an extended service warranty for most coaches that we sell! Our extended service is the most comprehensive service contract in the industry and will help you protect your investment.";
			
			faq4View.headerText.text = @"Why should I choose to travel to Nacogdoches for service work on my motorhome?";
			faq4View.contentText.text = @"Q: Why should I choose to travel to Nacogdoches for service work on my motorhome?\n\nA: We have over 100 years of service expertise on motorhomes and we have a reputation for excellent service for both our coaches and customers!  Don’t believe us? Read our customer testimonials at: http://motorhomesoftexas.com/testimonials";
			break;
			
		case FaqTypeRemodel:
			self.title = @"REMODEL CENTER";
			
			faq1View.headerText.text = @"What kind of remodeling work can Motorhomes of Texas do on my coach?";
			faq1View.contentText.text = @"Q: What kind of remodeling work can Motorhomes of Texas do on my coach?\n\nA: We can do all kinds of remodeling.  From installing new cabinetry, carpet, tile, or even furniture, we can bring new life into your tired coach!";
			
			faq2View.headerText.text = @"On average, how quickly can you remodel a coach?";
			faq2View.contentText.text = @"Q: On average, how quickly can you remodel a coach?\n\nA: It depends on the type of work being done, but if you are wanting only one or two jobs done, we can get you back into your coach as quickly as a few weeks!";
			
			faq3View.headerText.text = @"What kind of work can’t Motorhomes of Texas do on my coach?";
			faq3View.contentText.text = @"Q: What kind of work can’t Motorhomes of Texas do on my coach?\n\nA: Though we can do most any remodeling work in-house, we are limited to less consuming jobs.  If you are wanting a total renovation of your motorhome floorplan, we may not be able to accomplish that job in as timely or costly fashion as you deem acceptable.  It all depends on what you’re expecting and can afford.";
			
			faq4View.headerText.text = @"How do I set up an appointment to get my coach worked on and remodeled?";
			faq4View.contentText.text = @"Q: How do I set up an appointment to get my coach worked on and remodeled?\n\nA: Easy! You can email or call us directly to set up an appointment.  But please be aware that we may be limited to certain days and times when we can get your coach in for remodeling.  We will try to get you as close to your desired day and time as possible though, so just shoot us a line and we’ll get back to you!";
			break;
			
		case FaqTypeParts:
			self.title = @"PARTS & ACCESSORIES";
			
			faq1View.headerText.text = @"What are the Motorhomes of Texas parts policies and guarantees?";
			faq1View.contentText.text = @"Q: What are the Motorhomes of Texas parts policies and guarantees?\n\nA: Not specifically through Motorhomes of Texas, but each part we use and order has its own guarantee from the manufacturer of the part in question. We’ll be happy to handle any problems you may encounter with any part giving you trouble!";
			
			faq2View.headerText.text = @"Are there any parts that you don’t carry?";
			faq2View.contentText.text = @"Q: Are there any parts that you don’t carry?\n\nA: Unfortunately, yes.  We do not carry any parts for the National RV model Alpine motorhome. We also do not deal with used parts, except for certain types of furniture that meet our quality standards for reuse.";
			
			faq3View.headerText.text = @"Help! I don’t live in Texas and I need a part for my motorhome ASAP! What do I do?";
			faq3View.contentText.text = @"Q: Help! I don’t live in Texas and I need a part for my motorhome ASAP! What do I do?\n\nA: No worries, we’ve got you covered! We ship parts all over the U.S. and Canada to any address you give us or that we have on file.  Remember, if we don’t have it in-house, we can order it!";
			
			faq4View.headerText.text = @"On average, how quickly will my parts that I order ship to me?";
			faq4View.contentText.text = @"Q: On average, how quickly will my parts that I order ship to me?\n\nA: It depends of course on a variety of circumstances when dealing with U.S. postal service, such as location and weather.  But typically when we are shipping from our in-house inventory, it will be shipped the same day.  In cases of where we have to order a part for you, the part will arrive within just a few short days!";
			break;
			
		case FaqTypeConsignment:
			self.title = @"CONSIGNMENT";
			
			faq1View.headerText.text = @"Why consign with Motorhomes of Texas?";
			faq1View.contentText.text = @"Q: Why consign with Motorhomes of Texas?\n\nA: Motorhomes of Texas is your # 1 choice for motorhome trades and consignments! We help hundreds of customers sell their motorhomes every year throughout the U.S, and worldwide. Our experienced team is dedicated to ensuring that the sale or trade of your motorhome is as easy and streamlined as possible.";
			
			faq2View.headerText.text = @"Who handles my transactions?";
			faq2View.contentText.text = @"Q: Who handles my transactions?\n\nA: We have a dedicated team of experts who will help you throughout the entire consigning process. Our team knows these motorhomes inside and out, and they know what it takes to sell them quickly and easily.  They’ll even be there to answer your questions at any point in the process, and they’ll help you properly value your motorhome in a fair manner according to NADA guidelines.";
			
			faq3View.headerText.text = @"What if I wanted to trade my motorhome in?";
			faq3View.contentText.text = @"Q: What if I wanted to trade my motorhome in?\n\nA: In most cases, we offer immediate cash back for your trade-in so you can choose your next motorhome and get back on the road.";
			
			faq4View.headerText.text = @"What are some guarantees for me?";
			faq4View.contentText.text = @"Q: What are some guarantees for me?\n\nA: Some customers are uneasy about making a pre-owned purchase due to expired warranties, but rest assured because Motorhomes of Texas offers extended service contracts on most motorhomes we sell. Our extended service is the most comprehensive service contract in the industry and will help you protect your investment.";
			break;
			
		default:
			break;
	}
	
	faqViews = @[faq1View, faq2View, faq3View, faq4View];
	
	[scroll addSubview:faq1View];
	[scroll addSubview:faq2View];
	[scroll addSubview:faq3View];
	[scroll addSubview:faq4View];
	
	CGRect rect = faq1View.frame;
	rect.origin.y = 0;
	rect.size.width = scroll.frame.size.width;
	faq1View.frame = rect;
	
	rect = faq2View.frame;
	rect.origin.y = faq1View.frame.size.height;
	rect.size.width = scroll.frame.size.width;
	faq2View.frame = rect;
	
	rect = faq3View.frame;
	rect.origin.y = faq1View.frame.size.height*2;
	rect.size.width = scroll.frame.size.width;
	faq3View.frame = rect;
	
	rect = faq4View.frame;
	rect.origin.y = faq1View.frame.size.height*3;
	rect.size.width = scroll.frame.size.width;
	faq4View.frame = rect;
	
	scroll.contentSize = CGSizeMake(scroll.contentSize.width, faq1View.frame.size.height * faqViews.count);
}

#pragma mark TapToShowViewDelegate

-(void)tapToShowView:(TapToShowView*)view heightChanged:(float)height
{
	[UIView animateWithDuration:0.2f animations:^{
		CGSize size = scroll.contentSize;
		size.height += height;
		scroll.contentSize = size;
		
		BOOL isNext = NO;
		
		for (int i = 0; i < faqViews.count; i++)
		{
			if(!isNext)
			{
				if(faqViews[i] == view)
					isNext = YES;
			}
			else
			{
				CGRect rect = [faqViews[i] frame];
				rect.origin.y += height;
				[faqViews[i] setFrame:rect];
			}
		}
	}];
}

- (void)viewDidUnload
{
	scroll = nil;
	[super viewDidUnload];
}
@end
