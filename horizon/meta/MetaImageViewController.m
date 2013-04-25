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
