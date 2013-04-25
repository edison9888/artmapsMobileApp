//
//  WelcomeViewController.m
//  WordPress
//
//  Created by Dan Roundhill on 5/5/10.
//

#import "WelcomeViewController.h"
#import "SFHFKeychainUtils.h"
#import "WordPressAppDelegate.h"
#import "AboutViewController.h"
#import "AddUsersBlogsViewController.h"
#import "AddSiteViewController.h"
#import "EditSiteViewController.h"
#import "WebSignupViewController.h"
#import "WPcomLoginViewController.h"
#import "WordPressComApi.h"


@interface WelcomeViewController () <NSFetchedResultsControllerDelegate, WPcomLoginViewControllerDelegate> {
    WordPressAppDelegate *appDelegate;
}

@property (nonatomic, assign) WordPressAppDelegate *appDelegate;

//horizon code
@property (readonly) NSFetchedResultsController *resultsController;
//@property (nonatomic, retain) WordPressComApi *wpComApi;

- (void)blogsRefreshNotificationReceived:(NSNotification *)notification;

@end


@implementation WelcomeViewController {
    NSFetchedResultsController *_resultsController;
}


@synthesize appDelegate;

@synthesize buttonView;
@synthesize logoView;
@synthesize infoButton;
@synthesize orgBlogButton;
@synthesize addBlogButton;
@synthesize createBlogButton;
@synthesize createLabel;
//horizon code
@synthesize artMapButton;
@synthesize GLAButton;
@synthesize experienceView;
//@synthesize wpComApi;// = _wpComApi, blog = _blog;

#pragma mark -
#pragma mark View lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [buttonView release];
    [logoView release];
    [infoButton release];
    [orgBlogButton release];
    [addBlogButton release];
    [createBlogButton release];
    [createLabel release];
    //horizon code
    [artMapButton release];
    [GLAButton release];
    [experienceView release];
    [super dealloc];
}


- (void)viewDidLoad {
    [FileLogger log:@"%@ %@", self, NSStringFromSelector(_cmd)];
    [super viewDidLoad];
	
	appDelegate = (WordPressAppDelegate *)[[UIApplication sharedApplication] delegate];
    id delegate = [[UIApplication sharedApplication] delegate];
    experienceSelection = (ExperienceSelection *)[delegate experienceSelection];
    //[[ExperienceConfigurer sharedInstance] setSelectedBlog:self.blog];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"welcome_bg_pattern.png"]];
    //if()
    //self.experienceView.hidden = YES;
    // If there are blogs, this is being shown in the Settings.
    if ([Blog countWithContext:[WordPressAppDelegate sharedWordPressApp].managedObjectContext] > 0) {
        // Hide the Logo View on the iPhone, there isn't enough room for that and the navigation bar.
        //if(self. == nil){
        //self.experienceView.hidden = YES;
        //}
        if (IS_IPHONE) {
            self.logoView.hidden = YES;
            CGRect frame = buttonView.frame;
            frame.origin.y = 0.0f;
            buttonView.frame = frame;
        }
        createLabel.text = NSLocalizedString(@"If you want to start another blog:", @"");
    }else{
        self.experienceView.hidden = YES;
    }
}


- (void)viewDidUnload {
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.buttonView = nil;
    self.logoView = nil;
    self.infoButton = nil;
    self.orgBlogButton = nil;
    self.addBlogButton = nil;
    self.createBlogButton = nil;
    self.createLabel = nil;
    //horizon code
    self.artMapButton = nil;
    self.GLAButton = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    if (([Blog countWithContext:[WordPressAppDelegate sharedWordPressApp].managedObjectContext] <= 0 && ( ![WordPressComApi sharedApi].username )) || isFirstRun) {
        isFirstRun = YES;
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


- (NSUInteger)supportedInterfaceOrientations {
    if (IS_IPHONE) {
        if ([Blog countWithContext:[WordPressAppDelegate sharedWordPressApp].managedObjectContext] == 0) {
            return UIInterfaceOrientationMaskPortrait;
        }
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskAll;
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


#pragma mark -
#pragma mark Instance Methods


- (NSFetchedResultsController *)resultsController {
    if (_resultsController) {
        return _resultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *moc = [[WordPressAppDelegate sharedWordPressApp] managedObjectContext];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Blog" inManagedObjectContext:moc]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"blogName" ascending:YES]]];
    
    // For some reasons, the cache sometimes gets corrupted
    // Since we don't really use sections we skip the cache here
    _resultsController = [[NSFetchedResultsController alloc]
                          initWithFetchRequest:fetchRequest
                          managedObjectContext:moc
                          sectionNameKeyPath:nil
                          cacheName:nil];
    _resultsController.delegate = self;
    
    NSError *error = nil;
    if (![_resultsController performFetch:&error]) {
        WPFLog(@"Couldn't fetch blogs: %@", [error localizedDescription]);
        [_resultsController release];
        _resultsController = nil;
    }
    [fetchRequest release];
    return _resultsController;
}


- (IBAction)handleInfoTapped:(id)sender {
    [self showAboutView];
}


- (IBAction)handleOrgBlogTapped:(id)sender {
    AddSiteViewController *addSiteView = [[AddSiteViewController alloc] initWithNibName:nil bundle:nil];    
    [self.navigationController pushViewController:addSiteView animated:YES];
    [addSiteView release];
}


- (IBAction)handleAddBlogTapped:(id)sender {
    NSString *username = nil;
    NSString *password = nil;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_username_preference"] != nil) {
        NSError *error = nil;
        username = [[NSUserDefaults standardUserDefaults] objectForKey:@"wpcom_username_preference"];
        password = [SFHFKeychainUtils getPasswordForUsername:username
                                              andServiceName:@"WordPress.com"
                                                       error:&error];
    }
    
    if(appDelegate.isWPcomAuthenticated) {
        AddUsersBlogsViewController *addUsersBlogsView;
        if (IS_IPAD == YES)
            addUsersBlogsView = [[AddUsersBlogsViewController alloc] initWithNibName:@"AddUsersBlogsViewController-iPad" bundle:nil];
        else
            addUsersBlogsView = [[AddUsersBlogsViewController alloc] initWithNibName:@"AddUsersBlogsViewController" bundle:nil];
        addUsersBlogsView.isWPcom = YES;
        [addUsersBlogsView setUsername:username];
        [addUsersBlogsView setPassword:password];
        [self.navigationController pushViewController:addUsersBlogsView animated:YES];
        [addUsersBlogsView release];
    }
    else {
        WPcomLoginViewController *wpLoginView = [[WPcomLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
        wpLoginView.delegate = self;
        [self.navigationController pushViewController:wpLoginView animated:YES];
        [wpLoginView release];
    }
}


- (IBAction)handleCreateBlogTapped:(id)sender {
    NSString *newNibName = @"WebSignupViewController";
    if(IS_IPAD == YES)
        newNibName = @"WebSignupViewController-iPad";
    WebSignupViewController *webSignup = [[WebSignupViewController alloc] initWithNibName:newNibName bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:webSignup animated:YES];
    [webSignup release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpcomSignupNotificationReceived:) name:@"wpcomSignupNotification" object:nil];
}


//horizon code
- (IBAction)handleArtMapExperience:(id)sender {
    Blog *blog = [self.resultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[ExperienceConfigurer sharedInstance] setSelectedBlog:blog];
    [[ExperienceConfigurer sharedInstance] setSelectedExperience:@"Tate"];
    experienceSelection.selectedExperience = @"artmaps";
    HIOoIViewController *addArtMapView = [[HIOoIViewController alloc] initWithNibName:nil bundle:nil];
    [addArtMapView setBlog:blog];
    [self.navigationController pushViewController:addArtMapView animated:YES];
    [addArtMapView release];
}

- (IBAction)handleGLAExperience:(id)sender {
    Blog *blog = [self.resultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [[ExperienceConfigurer sharedInstance] setSelectedBlog:blog];
    experienceSelection.selectedExperience =  @"gla";
    [[ExperienceConfigurer sharedInstance] setSelectedExperience:@"GLA"];
    HIOoIViewController *addGLAView = [[HIOoIViewController alloc] initWithNibName:nil bundle:nil];
    [addGLAView setBlog:blog];
    [self.navigationController pushViewController:addGLAView animated:YES];
    [addGLAView release];
}


#pragma mark -
#pragma mark Custom methods

// Add itself as observer for the 'BlogsRefreshNotification' notification. It is used when the app shows the Welcome Screen, since this Screen need to be dismissed upon login action
-(void) automaticallyDismissOnLoginActions {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blogsRefreshNotificationReceived:) name:@"BlogsRefreshNotification" object:nil];    
}


// Called when the AppDelegate receives an URL like 'wordpress://wpcom_signup_completed'
- (void)wpcomSignupNotificationReceived:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wpcomSignupNotification" object:nil];
    NSDictionary *info = [notification userInfo];
    WPFLog(@"Info received in the notification %@", info);
    [self.navigationController popViewControllerAnimated:NO];
    WPcomLoginViewController *wpLoginView = [[WPcomLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
    wpLoginView.delegate = self;
    wpLoginView.predefinedUsername = [info valueForKey:@"username"];
    [self.navigationController pushViewController:wpLoginView animated:YES];
    [wpLoginView release];
}


- (void)blogsRefreshNotificationReceived:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BlogsRefreshNotification" object:nil];
    [super dismissModalViewControllerAnimated:YES];
}


- (IBAction)cancel:(id)sender {
	[super dismissModalViewControllerAnimated:YES];
}

- (void)showAboutView {
    AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
	aboutViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    nc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentModalViewController:nc animated:YES];
    [aboutViewController release];
    [nc release];
}

#pragma mark - WPcomLoginViewControllerDelegate

- (void)loginControllerDidDismiss:(WPcomLoginViewController *)loginController {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)loginController:(WPcomLoginViewController *)loginController didAuthenticateWithUsername:(NSString *)username {
    [self.navigationController popViewControllerAnimated:NO];
    [self handleAddBlogTapped:nil];
}


@end
