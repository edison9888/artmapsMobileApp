//
//  MetaDataGLAViewController.m
//  WordPress
//
//  Created by lavdrus on 29/11/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "MetaDataGLAViewController.h"
#import "HIEditPostViewController.h"
#import "ExperienceConfigurer.h"
#import "PostMapLocation.h"
//#import "ImageDownloader.h"
//#import "MetaImageViewCell.h"
//#import "MetaImageViewController.h"

#define kAllegianceCellHeight 80
#define kEventCellHeight 80
#define kNameCellHeight 80
#define kYearCellHeight 80

@interface MetaDataGLAViewController ()
//@property (nonatomic,retain) ImageDownloader *imageDownloader;
@property (nonatomic,retain) NSIndexPath *imageCellIndexPath;


-(void)showAddPostView;
-(void)postViewDismissed:(id)notification;
@end

@implementation MetaDataGLAViewController

@synthesize ooiMeta;
@synthesize postMapLocation;
//@synthesize imageDownloader;
@synthesize imageCellIndexPath;
@synthesize ooiID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postViewDismissed:) name:@"PostEditorDismissed" object:nil];
    /*if (ooiMeta.imageurl != nil){
        imageDownloader = [[ImageDownloader alloc] initWithImageURL:ooiMeta.imageurl];
    }*/
}

-(void)setupNavigationBar{
    self.navigationItem.title = [[[ExperienceConfigurer sharedInstance] currentExperience] getTitleForOoI];
    [self setupRightBarButtonItem];
}

-(void)setupRightBarButtonItem{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showAddPostView)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.postMapLocation = nil;
    self.ooiMeta = nil;
    //self.imageDownloader.delegate = nil;
    //self.imageDownloader = nil;
    self.imageCellIndexPath = nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [postMapLocation release];
    [ooiMeta release];
    //imageDownloader.delegate = nil;
    //[imageDownloader release];
    [imageCellIndexPath release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NO_OF_GLASECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == kAllegiance)
        return kAllegianceCellHeight;
    else if (indexPath.section == kEvent)
        return kEventCellHeight;
    else if (indexPath.section == kName)
        return kNameCellHeight;
    else if (indexPath.section == kYear)
        return kYearCellHeight;
    else {
        return kCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case kAllegiance:
            cell = [self cellForAllegiance:tableView];
            break;
        case kEvent:
            cell = [self cellForEvent:tableView];
            break;
        case kName:
            cell = [self cellForName:tableView];
            break;
        case kYear:
            cell = [self cellForYear:tableView];
            break;
        default:
            break;
    }
    return cell;
}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == kImageUrl) && (imageDownloader.image != nil)){
        MetaImageViewController *metaImageViewController = [[MetaImageViewController alloc] initWithNibName:@"MetaImageViewController" bundle:nil];
        metaImageViewController.image = imageDownloader.image;
        [self.navigationController pushViewController:metaImageViewController animated:YES];
        metaImageViewController.navigationItem.title = self.navigationItem.title;
        [metaImageViewController release];
    }
}*/

-(UITableViewCell*)cellForAllegiance:(UITableView*)tableView{
    static NSString *AllegianceCellIdentifier = @"AllegianceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AllegianceCellIdentifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AllegianceCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = NSLocalizedString(@"Allegiance", nil);
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = ooiMeta.allegiance; //[ooiMeta.artist stringByAppendingFormat:@" %@",ooiMeta.artistdate];
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    [cell.detailTextLabel sizeToFit];
    return cell;
}

-(UITableViewCell*)cellForEvent:(UITableView*)tableView{
    static NSString *EventCellIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventCellIdentifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EventCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = NSLocalizedString(@"Event", nil);
    cell.detailTextLabel.text = ooiMeta.event;
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    cell.detailTextLabel.numberOfLines = 0;
    [cell.detailTextLabel sizeToFit];
    return cell;
}

-(UITableViewCell*)cellForName:(UITableView*)tableView{
    static NSString *NameCellIdentifier = @"NameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCellIdentifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NameCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = NSLocalizedString(@"Name", nil);
    cell.detailTextLabel.text = ooiMeta.name;
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    cell.detailTextLabel.numberOfLines = 0;
    [cell.detailTextLabel sizeToFit];
    return cell;
}

-(UITableViewCell*)cellForYear:(UITableView*)tableView{
    static NSString *YearCellIdentifier = @"YearCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YearCellIdentifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:YearCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = NSLocalizedString(@"Year", nil);
    cell.detailTextLabel.text = ooiMeta.year;
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
    cell.detailTextLabel.numberOfLines = 0;
    [cell.detailTextLabel sizeToFit];
    return cell;
}


/*-(UITableViewCell*)cellForImage:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath{
    static NSString *ImageCellIdentifier = @"MetaImageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ImageCellIdentifier];
    if (cell == nil){
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"MetaImageViewCell" owner:self options:nil];
        cell = (MetaImageViewCell*)[nib objectAtIndex:0];
        //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    MetaImageViewCell *metaImageViewCell = (MetaImageViewCell*)cell;
    self.imageCellIndexPath = indexPath;
    if (ooiMeta.imageurl != nil){
        if (imageDownloader.image != nil){
            [metaImageViewCell.spinner stopAnimating];
            cell.imageView.image = [imageDownloader.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:cell.imageView.frame.size interpolationQuality:kCGInterpolationDefault];
        }else {
            [metaImageViewCell.spinner startAnimating];
            imageDownloader.delegate = self;
        }
    }else {
        cell.imageView.image = [UIImage imageNamed:@"imagenotavailable"];
    }
    
    metaImageViewCell.artworkdateLabel.text = ooiMeta.artworkdate;
    [metaImageViewCell.artworkdateLabel sizeToFit];
    metaImageViewCell.referenceLabel.text = ooiMeta.reference;
    return cell;
}*/


- (void)showAddPostView {
    Post *post = [Post newDraftForBlog:[ExperienceConfigurer sharedInstance].selectedBlog];
    HIEditPostViewController *editPostViewController = [[[HIEditPostViewController alloc] initWithPost:[post createRevision]] autorelease];
    editPostViewController.editMode = kNewPost;
    [editPostViewController refreshUIForCompose];
    editPostViewController.postMapLocation = self.postMapLocation;
    editPostViewController.ooiID = self.ooiID;
    editPostViewController.ooiMetaGLA = self.ooiMeta;
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:editPostViewController] autorelease];
    navController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self.navigationController presentModalViewController:navController animated:YES];
    [post release];
}


-(void)postViewDismissed:(id)notification{
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - ImageDownloaderDelegate

/*-(void)imageDownloader:(ImageDownloader *)imageDownloader didLoadImage:(UIImage *)image{
    self.imageDownloader.delegate = nil;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.imageCellIndexPath] withRowAnimation:NO];
}

-(void)imageDownloader:(ImageDownloader *)imageDownloader didFailWithError:(NSError *)error{
    self.imageDownloader.delegate = nil;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:NSLocalizedString(@"Your connection appears to be offline", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}*/

@end