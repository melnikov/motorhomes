//
//  GalleryController.m
//  MotorHomes
//
//  Created by admin on 03.12.13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "GalleryController.h"

@interface GalleryController ()
{
	IBOutlet UIScrollView *scroll;
	IBOutlet UIPageControl *pageControl;
	NSArray * images;
}

@end

@implementation GalleryController

- (id)initWithImages:(NSArray*)_images
{
    self = [super init];
    if (self) {
        // Custom initialization
		images = _images;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"GALLERY";
	
	int x = 0;
	int y = 110;
	
	if(!IS_IPAD)
		y = 90;
	
	for (int i = 0; i < images.count; i++)
	{
		UIImageView * iv = [UIImageView new];
		iv.frame = CGRectMake(x, y, scroll.frame.size.width, scroll.frame.size.width * 0.6f);
		
		[iv setImageWithURL:[NSURL URLWithString:images[i]]];
		
		[scroll addSubview:iv];
		
		x += scroll.frame.size.width;
	}
	
	pageControl.numberOfPages = images.count;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	scroll.contentSize = CGSizeMake(scroll.frame.size.width * images.count, scroll.frame.size.height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scroll.frame.size.width;
    int page = floor((scroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	scroll = nil;
	pageControl = nil;
	[super viewDidUnload];
}
@end
