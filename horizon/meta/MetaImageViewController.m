//
//  UIMetaImageViewControllerViewController.m
//  WordPress
//
//  Created by Shakir Ali on 10/08/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "MetaImageViewController.h"
#import "UIImage+Resize.h"

@interface MetaImageViewController ()

@end

@implementation MetaImageViewController

@synthesize imageView;
@synthesize image;
@synthesize pinchRecognizer;
@synthesize panRecognizer;

int mLastScale = 1;
int mScale;
int mCurrentScale;

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
    if (self.image != nil ){
        self.imageView.image = [self.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:self.imageView.frame.size interpolationQuality:kCGInterpolationDefault];
    }
}

- (void)handlePinchRecognizer:(UIPinchGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)dragRecognizer {
    CGPoint translation = [dragRecognizer translationInView:imageView];
    imageView.transform = CGAffineTransformTranslate(imageView.transform, translation.x, translation.y);
    [dragRecognizer setTranslation:CGPointZero inView:imageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.image = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [imageView release];
    [image release];
    [super dealloc];
}
@end
