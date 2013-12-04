//
//  FaqController.m
//  MotorHomes
//
//  Created by admin on 03.12.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "FaqController.h"
#import "TapToShowView.h"

@interface FaqController ()
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"FAQ";
	
	faq1View = [[NSBundle mainBundle] loadNibNamed:@"TapToShowView" owner:self options:nil][0];
	faq1View.headerText.text = @"About our consignment program";
	faq1View.contentText.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
	faq1View.delegate = self;
	
	faq2View = [[NSBundle mainBundle] loadNibNamed:@"TapToShowView" owner:self options:nil][0];
	faq2View.headerText.text = @"Why should you consign with us?";
	faq2View.contentText.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
	faq2View.delegate = self;
	
	faq3View = [[NSBundle mainBundle] loadNibNamed:@"TapToShowView" owner:self options:nil][0];
	faq3View.headerText.text = @"Frequently Asked Questions and Answers";
	faq3View.contentText.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
	faq3View.delegate = self;
	
	faq4View = [[NSBundle mainBundle] loadNibNamed:@"TapToShowView" owner:self options:nil][0];
	faq4View.headerText.text = @"Our consignment Testimomials";
	faq4View.contentText.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
	faq4View.delegate = self;
	
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
	
	if(IS_IPAD)
	{
		for (int i = 0; i < faqViews.count; i++)
		{
			((TapToShowView*)faqViews[i]).headerText.font = [UIFont systemFontOfSize:18];
			((TapToShowView*)faqViews[i]).headerText.textAlignment = UITextAlignmentCenter;
			
			((TapToShowView*)faqViews[i]).contentText.font = [UIFont systemFontOfSize:18];
		}
	}
	
	scroll.contentSize = CGSizeMake(scroll.contentSize.width, faq1View.frame.size.height * faqViews.count);
}

-(void)tapToShowViewFrameChanged:(NSDictionary*)dict
{
	[UIView animateWithDuration:0.2f animations:^{
		CGSize size = scroll.contentSize;
		size.height += [[dict valueForKey:@"change"] floatValue];
		scroll.contentSize = size;
		
		BOOL isNext = NO;
		
		for (int i = 0; i < faqViews.count; i++)
		{
			if(!isNext)
			{
				if(faqViews[i] == [dict objectForKey:@"view"])
					isNext = YES;
			}
			else
			{
				CGRect rect = [faqViews[i] frame];
				rect.origin.y += [[dict valueForKey:@"change"] floatValue];
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
