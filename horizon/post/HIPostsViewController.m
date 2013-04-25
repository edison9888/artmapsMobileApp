//
//  HIPostsViewController.m
//  WordPress
//
//  Created by horizon on 02/10/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "HIPostsViewController.h"
#import "HIEditPostViewController.h"

@interface HIPostsViewController ()

@end

@implementation HIPostsViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Copied from PostsViewController and changed EditPostViewController to HIEditPostViewController.
// For iPhone
- (void)editPost:(AbstractPost *)apost {
    HIEditPostViewController *editPostViewController = [[[HIEditPostViewController alloc] initWithPost:[apost createRevision]] autorelease];
    editPostViewController.editMode = kEditPost;
    //This function is called from viewDidLoad so may be good to comment it.
    //[editPostViewController refreshUIForCurrentPost];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:editPostViewController] autorelease];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self.panelNavigationController presentModalViewController:navController animated:YES];
}

- (void)showAddPostView {
    NSString *msg = NSLocalizedString(@"You can compose normal post from here. To post for ArtMaps please select Map option from the main menu.",nil);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post", @"")
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel?", @"")
                                              otherButtonTitles:NSLocalizedString(@"Compose Post", @""), nil];
    [alertView show];
    [alertView release];
    
}

#pragma mark UIAlertViewDelegate.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //if OK button is pressed.
    if (buttonIndex == 1){
        [super showAddPostView];
    }
}

@end
