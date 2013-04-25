//
//  ExperienceViewController.h
//  WordPress
//
//  Created by lavdrus on 12/11/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIOoIViewController.h"
#import "ExperienceSelection.h"


@class Post;

@interface ExperienceViewController : UIViewController{
    ExperienceSelection *experienceSelection;
}

@property (nonatomic, retain) Blog *blog;
@property (nonatomic, retain) IBOutlet UIButton *artMapButton;
@property (nonatomic, retain) IBOutlet UIButton *GLAButton;


- (IBAction)handleArtMapExperience:(id)sender;
- (IBAction)handleGLAExperience:(id)sender;

@end
