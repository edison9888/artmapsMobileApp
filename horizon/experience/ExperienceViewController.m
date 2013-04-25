//
//  ExperienceViewController.m
//  WordPress
//
//  Created by lavdrus on 12/11/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "ExperienceViewController.h"
#import "ExperienceConfigurer.h"
#import "PostsViewController.h"
#import "WPReaderViewController.h"
#import "StatsWebViewController.h"


@interface ExperienceViewController ()


@end

@implementation ExperienceViewController

@synthesize artMapButton;
@synthesize GLAButton;
@synthesize blog;

#pragma mark -
#pragma mark View lifecycle


- (void)dealloc {
    [artMapButton release];
    [GLAButton release];
    [blog release];
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"Choose Experience";
    id delegate = [[UIApplication sharedApplication] delegate];
    experienceSelection = (ExperienceSelection *)[delegate experienceSelection];
    [[ExperienceConfigurer sharedInstance] setSelectedBlog:self.blog];
}

- (void)viewDidUnload {
    [super viewDidUnload];

    self.artMapButton = nil;
    self.GLAButton = nil;
    self.blog = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleArtMapExperience:(id)sender {
    experienceSelection.selectedExperience = @"artmaps";
    [[ExperienceConfigurer sharedInstance] setSelectedExperience:@"Tate"];
    HIOoIViewController *addArtMapView = [[HIOoIViewController alloc] initWithNibName:nil bundle:nil];
    [addArtMapView setBlog:self.blog];
    [self.navigationController pushViewController:addArtMapView animated:YES];
    [addArtMapView release];
}

- (IBAction)handleGLAExperience:(id)sender {
    experienceSelection.selectedExperience = @"gla";
    [[ExperienceConfigurer sharedInstance] setSelectedExperience:@"GLA"];
    HIOoIViewController *addGLAView = [[HIOoIViewController alloc] initWithNibName:nil bundle:nil];
    [addGLAView setBlog:self.blog];
    [self.navigationController pushViewController:addGLAView animated:YES];
    [addGLAView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPAD || interfaceOrientation == UIDeviceOrientationPortrait)
        return YES;
    else if (IS_IPHONE && [Blog countWithContext:[WordPressAppDelegate sharedWordPressApp].managedObjectContext] > 0)
        return YES;
    else
        return NO;
}


@end
