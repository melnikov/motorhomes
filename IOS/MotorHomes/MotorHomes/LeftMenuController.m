//
//  LeftMenuController.m
//  StreetBee
//
//  Created by admin on 8/15/13.
//  Copyright (c) 2013 StexGroup. All rights reserved.
//

#import "LeftMenuController.h"

#import "AppDelegate.h"

@interface LeftMenuController ()
{
	IBOutlet UIImageView *userPic;
	IBOutlet UIButton *loginButton;
	IBOutlet UIView *accountBlocker;
	IBOutlet UIScrollView *scroll;
	IBOutlet UIView *scrollContent;
}

@end

@implementation LeftMenuController

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
	
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
	
	[scroll addSubview:scrollContent];
	
	scroll.contentSize = CGSizeMake(scroll.contentSize.width, scrollContent.frame.size.height);
	
	//scroll.frame = [[UIScreen mainScreen] bounds];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Add User Image 

- (IBAction)addUserImagePressed {
	[[[UIActionSheet alloc] initWithTitle:@"Загрузить фото:" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"С камеры", @"Из альбома", nil] showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) return;
    
	UIImagePickerController *imagePicker =[[UIImagePickerController alloc] init];
	imagePicker.delegate = (id)self;
	imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
	
	if(buttonIndex == 0)
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	else if(buttonIndex == 1)
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	imagePicker.allowsEditing = YES;
    [self presentModalViewController:imagePicker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
	{
		// Media is an image
		UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
		
		[userPic setImage:image];
    }
}

- (UIImage *)resizeImage:(UIImage *)image width:(int)wdth height:(int)hght
{
    int w = image.size.width;
    int h = image.size.height;
    CGImageRef imageRef = [image CGImage];
    int width, height;
    int destWidth = wdth;
    int destHeight = hght;
    if(w > h){
        width = destWidth;
        height = h*destWidth/w;
    }
    else {
        height = destHeight;
        width = w*destHeight/h;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap;
    bitmap = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
	
    if (image.imageOrientation == UIImageOrientationLeft) {
		
        CGContextRotateCTM (bitmap, M_PI/2);
        CGContextTranslateCTM (bitmap, 0, -height);
		
    } else if (image.imageOrientation == UIImageOrientationRight) {
		
        CGContextRotateCTM (bitmap, -M_PI/2);
        CGContextTranslateCTM (bitmap, -width, 0);
		
    }
    else if (image.imageOrientation == UIImageOrientationUp) {
		
    } else if (image.imageOrientation == UIImageOrientationDown) {
		
        CGContextTranslateCTM (bitmap, width,height);
        CGContextRotateCTM (bitmap, -M_PI);
    }
	
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return result;
}

- (UIImage*)cropImage:(UIImage*)image toSize:(CGSize)toSize
{
	// ger the original image along with it's size
	CGSize size = image.size;
	
	// crop the crop rect that the user selected
	CGRect cropRect = CGRectMake(0, size.height / 2 - toSize.height / 2, toSize.width, toSize.height);
	
	//cropRect.size = toSize;
	
	// create a graphics context of the correct size
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// correct for image orientation
	UIImageOrientation orientation = [image imageOrientation];
	if(orientation == UIImageOrientationUp) {
		CGContextTranslateCTM(context, 0, size.height);
		CGContextScaleCTM(context, 1, -1);
		cropRect = CGRectMake(cropRect.origin.x,
							  -cropRect.origin.y,
							  cropRect.size.width,
							  cropRect.size.height);
	} else if(orientation == UIImageOrientationRight) {
		CGContextScaleCTM(context, 1.0, -1.0);
		CGContextRotateCTM(context, -M_PI/2);
		size = CGSizeMake(size.height, size.width);
		cropRect = CGRectMake(cropRect.origin.y,
							  cropRect.origin.x,
							  cropRect.size.height,
							  cropRect.size.width);
	} else if(orientation == UIImageOrientationDown) {
		CGContextTranslateCTM(context, size.width, 0);
		CGContextScaleCTM(context, -1, 1);
		cropRect = CGRectMake(-cropRect.origin.x,
							  cropRect.origin.y,
							  cropRect.size.width,
							  cropRect.size.height);
	}
	// draw the image in the correct place
	CGContextTranslateCTM(context, -cropRect.origin.x, -cropRect.origin.y);
	CGContextDrawImage(context,
					   CGRectMake(0,0, size.width, size.height),
					   image.CGImage);
	// and pull out the cropped image
	UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return croppedImage;
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
	scroll = nil;
	scrollContent = nil;
	userPic = nil;
	[super viewDidUnload];
}
@end
