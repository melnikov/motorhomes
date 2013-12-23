//
//  VideoController.m
//  MotorHomes
//
//  Created by admin on 23.12.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "VideoController.h"

@interface VideoController ()
{
	IBOutlet UIView *blackView;
	IBOutlet UIWebView *webView;
	
	NSString * url;
	
	CGRect rect;
}

@end

@implementation VideoController

-(id)initWithURL:(NSString *)urlString frame:(CGRect)frame;
{
	if (self = [super init])
	{
		// Create webview with requested frame size
		webView = [[UIWebView alloc] initWithFrame:frame];
		
		url = urlString;
		
		rect = frame;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"VIDEO";
	
	CGSize size = [[UIScreen mainScreen] bounds].size;
	
	// HTML to embed YouTube video
	NSString *youTubeVideoHTML = [NSString stringWithFormat:@"<!doctype html>\
	<html>\
	<style>body{padding:0;margin:0;background-color: #000000;}</style>\
	<iframe width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/%@?rel=0\" frameborder=\"0\"></iframe>\
	</html>", size.height, size.width - 20, url];
	
	// Load the html into the webview
	[webView loadHTMLString:youTubeVideoHTML baseURL:nil];
	
	webView.scrollView.scrollEnabled = NO;
	
	webView.delegate = self;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
	blackView.hidden = YES;
}

-(BOOL)shouldAutorotate
{
	return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
		return YES;
	
	return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskLandscape;
}

- (IBAction)donePressed
{
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
	webView = nil;
	blackView = nil;
	[super viewDidUnload];
}
@end
