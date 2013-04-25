//
//  MetaListTableViewController.m
//  WordPress
//
//  Created by Shakir Ali on 04/08/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "MetaListTableViewController.h"
#import "PostMapLocation.h"
#import "OoIMeta.h"
#import "OoIMetaLoader.h"
#import "MetaTableViewController.h"
#import "MetaDataGLAViewController.h"
#import "ExperienceConfigurer.h"
#import "WordPressAppDelegate.h"

@interface MetaListTableViewController ()
@property (nonatomic, retain) NSMutableDictionary *metaLoadersInProgress;
@property (nonatomic, retain) NSMutableDictionary *ooiMetaDict;
//-(void)postViewDismissed:(id)notification;
@end

@implementation MetaListTableViewController

@synthesize ooI_IDs;
@synthesize postMapLocation;
@synthesize metaLoadersInProgress;
@synthesize ooiMetaDict;

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
    WordPressAppDelegate *appDelegate = [WordPressAppDelegate sharedWordPressApp];
    if (appDelegate.connectionAvailable == NO){
        [self displayInternetConnectionMessage];
    }
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postViewDismissed:) name:@"PostEditorDismissed" object:nil];
    self.metaLoadersInProgress = [NSMutableDictionary dictionary];
    self.ooiMetaDict = [NSMutableDictionary dictionary];
    self.navigationItem.title = [[[ExperienceConfigurer sharedInstance] currentExperience] getTitleForOoI];
}

-(void)displayInternetConnectionMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:NSLocalizedString(@"Your interent connection appears to be offline", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}
    
-(void)cancelMetaLoadRequests{
    NSArray *allMetaLoaders = [self.metaLoadersInProgress allValues];
    [allMetaLoaders makeObjectsPerformSelector:@selector(cancelMetaLoad)];
    [self.metaLoadersInProgress removeAllObjects];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancelMetaLoadRequests];
    self.metaLoadersInProgress = nil;
    self.ooI_IDs = nil;
    self.postMapLocation = nil;
    self.ooiMetaDict = nil;
}

#pragma mark - memory management

-(void)dealloc{
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    NSArray *allMetaLoaders = [self.metaLoadersInProgress allValues];
    [allMetaLoaders makeObjectsPerformSelector:@selector(cancelMetaLoad)];
    [metaLoadersInProgress release];
    [ooI_IDs release];
    [postMapLocation release];
    [ooiMetaDict release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // terminate all pending download connections
    [self cancelMetaLoadRequests];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   // Return the number of sections.
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ooI_IDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    }
    
    NSString* title = [[[ExperienceConfigurer sharedInstance] currentExperience] getTitleForOoIList];
    if(title == @"TATE - Art Maps"){
        OoIMeta *meta = [self.ooiMetaDict objectForKey:indexPath];
        if (meta != nil){
            [self displayOoIMeta:meta inTableViewCell:cell];
        }else{
            WordPressAppDelegate *appDelegate = [WordPressAppDelegate sharedWordPressApp];
            if (appDelegate.connectionAvailable == YES){
                cell.textLabel.text = NSLocalizedString(@"Loading...", nil);
                cell.detailTextLabel.text = @"";
                [self submitMetaLoaderRequestForIndexPath:indexPath];
            }
        }
    }else if (title == @"Gender L. America"){
        OoIMetaGLA *metaGLA = [self.ooiMetaDict objectForKey:indexPath];
        if (metaGLA != nil){
            [self displayOoIMetaGLA:metaGLA inTableViewCell:cell];
        }else{
            WordPressAppDelegate *appDelegate = [WordPressAppDelegate sharedWordPressApp];
            if (appDelegate.connectionAvailable == YES){
                cell.textLabel.text = NSLocalizedString(@"Loading...", nil);
                cell.detailTextLabel.text = @"";
                [self submitMetaLoaderRequestForIndexPath:indexPath];
            }
        }
    }
    return cell;
}

-(void)submitMetaLoaderRequestForIndexPath:(NSIndexPath*)indexPath{
    OoIMetaLoader *metaLoader = [metaLoadersInProgress objectForKey:indexPath];
    if (metaLoader == nil){
        OoIMetaLoader *metaLoader = [[OoIMetaLoader alloc] init];
        metaLoader.delegate = self;
        [metaLoader submitOoIMetaRequestWithID:[ooI_IDs objectAtIndex:indexPath.row] forIndexPathInTableView:indexPath];
        [metaLoadersInProgress setObject:metaLoader forKey:indexPath];
        [metaLoader release];
    }
}

-(void)displayOoIMeta:(OoIMeta*)meta inTableViewCell:(UITableViewCell*)cell{
    cell.textLabel.text = meta.title;
    cell.detailTextLabel.text = meta.artist;
}


-(void)displayOoIMetaGLA:(OoIMetaGLA*)metaGLA inTableViewCell:(UITableViewCell*)cell{
    cell.textLabel.text = metaGLA.name;
    cell.detailTextLabel.text = metaGLA.allegiance;
}
/*
-(void)postViewDismissed:(id)notification{
    [self.navigationController popViewControllerAnimated:YES];
}*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* title = [[[ExperienceConfigurer sharedInstance] currentExperience] getTitleForOoIList];
    if(title == @"TATE - Art Maps"){
        OoIMeta *meta = [ooiMetaDict objectForKey:indexPath];
        if (meta != nil){
            MetaTableViewController *metaTableViewController = [[MetaTableViewController alloc] initWithNibName:@"MetaTableViewController" bundle:nil];
            NSNumber *id = [ooI_IDs objectAtIndex:indexPath.row];
            metaTableViewController.ooiID = [id intValue];
            metaTableViewController.ooiMeta = meta;
            metaTableViewController.postMapLocation = postMapLocation;
            [self.navigationController pushViewController:metaTableViewController animated:YES];
            [metaTableViewController release];
        }
    }else if (title == @"Gender L. America"){
        OoIMetaGLA *metaGLA = [ooiMetaDict objectForKey:indexPath];
        if (metaGLA != nil){
            MetaDataGLAViewController *metaDataGLAViewController = [[MetaDataGLAViewController alloc] initWithNibName:@"MetaDataGLAViewController" bundle:nil];
            NSNumber *id = [ooI_IDs objectAtIndex:indexPath.row];
            metaDataGLAViewController.ooiID = [id intValue];
            metaDataGLAViewController.ooiMeta = metaGLA;
            metaDataGLAViewController.postMapLocation = postMapLocation;
            [self.navigationController pushViewController:metaDataGLAViewController animated:YES];
            [metaDataGLAViewController release];
        }
    }
    
}

#pragma mark - OoIMetaLoaderDelegate
-(void)metaDataDidLoad:(OoIMeta *)ooiMeta forIndexPath:(NSIndexPath *)indexPath{
    OoIMetaLoader *metaLoader = [metaLoadersInProgress objectForKey:indexPath];
    if (metaLoader != nil){
        [ooiMetaDict setObject:ooiMeta forKey:indexPath];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        metaLoader.delegate = nil;
    }
}

-(void)metaDataDidLoadGLA:(OoIMetaGLA *)ooiMetaGLA forIndexPath:(NSIndexPath *)indexPath{
    OoIMetaLoader *metaLoader = [metaLoadersInProgress objectForKey:indexPath];
    if (metaLoader != nil){
        [ooiMetaDict setObject:ooiMetaGLA forKey:indexPath];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        metaLoader.delegate = nil;
    }
}

-(void)OoIMetaLoader:(OoIMetaLoader *)loader didFailWithError:(NSError *)error{
    [self cancelMetaLoadRequests];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:self.title message:error.userInfo.description delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

@end
