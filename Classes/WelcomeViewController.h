//
//  WelcomeViewController.h
//  WordPress
//
//  Created by Dan Roundhill on 5/5/10.
//

#import <UIKit/UIKit.h>
#import "ExperienceSelection.h"
#import "ExperienceConfigurer.h"
#import "HIOoIViewController.h"

@interface WelcomeViewController : UIViewController {
    BOOL isFirstRun;
    ExperienceSelection *experienceSelection;
}

@property (nonatomic, retain) IBOutlet UIView *logoView;
@property (nonatomic, retain) IBOutlet UIView *buttonView;
@property (nonatomic, retain) IBOutlet UIView *experienceView;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *orgBlogButton;
@property (nonatomic, retain) IBOutlet UIButton *addBlogButton;
@property (nonatomic, retain) IBOutlet UIButton *createBlogButton;
@property (nonatomic, retain) IBOutlet UILabel *createLabel;
@property (nonatomic, retain) IBOutlet UIButton *artMapButton;
@property (nonatomic, retain) IBOutlet UIButton *GLAButton;

- (IBAction)handleInfoTapped:(id)sender;
- (IBAction)handleOrgBlogTapped:(id)sender;
- (IBAction)handleAddBlogTapped:(id)sender;
- (IBAction)handleCreateBlogTapped:(id)sender;
- (IBAction)handleArtMapExperience:(id)sender;
- (IBAction)handleGLAExperience:(id)sender;


- (IBAction)cancel:(id)sender;
- (void)automaticallyDismissOnLoginActions; //used when shown as a Real Welcome controller
- (void)showAboutView;

@end
