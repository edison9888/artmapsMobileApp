//
//  HIEditPostViewController.m
//  WordPress
//
//  Created by horizon on 28/09/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "HIEditPostViewController.h"
#import "PostMapLocation.h"
#import "OoIMeta.h"
#import "OoIMetaGLA.h"
#import "ExperienceConfigurer.h"
#import "TouchXML.h"
#import "DDXML.h"
#import "MAZeroingWeakRef.h"

@interface HIEditPostViewController ()
    @property (nonatomic, retain) NSMutableArray* mediaHtmlList;
@end

@implementation HIEditPostViewController

@synthesize postMapLocation;
@synthesize ooiMeta;
@synthesize ooiMetaGLA;
@synthesize ooiID;
@synthesize postCommentsTemplate;
@synthesize postCommentOperation;
@synthesize xmlRpcClient;
@synthesize mediaHtmlList;
@synthesize postDetailViewController;

const NSInteger MEDIA_NOT_FOUND = -1;


- (id)initWithPost:(AbstractPost *)aPost {
    NSString *nib;
    if (IS_IPAD) {
        nib = @"EditPostViewController-iPad";
    } else {
        nib = @"HIEditPostViewController";
    }
    
    if (self = [super initWithNibName:nib bundle:nil]) {
        self.apost = aPost;
        mediaHtmlList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/*
- (id)initWithPost:(AbstractPost *)aPost {
    if (self = [super initWithPost:aPost]){
        mediaHtmlList = [[NSMutableArray alloc] init];
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.editMode == kNewPost)
        [self downloadPostCommentTemplateForOoi];
    
}

-(void)viewDidUnload
{
    self.postMapLocation = nil;
    self.ooiMeta = nil;
    self.ooiMetaGLA = nil;
    self.postCommentsTemplate = nil;
    [self.postCommentOperation cancel];
    self.postCommentOperation = nil;
    [self.xmlRpcClient cancelAllHTTPOperations];
    self.xmlRpcClient = nil;
    self.postDetailViewController = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [postMapLocation release];
    [ooiMeta release];
    [ooiMetaGLA release];
    [postCommentsTemplate release];
    [postCommentOperation release];
    [xmlRpcClient release];
    [mediaHtmlList release];
    postDetailViewController = nil;
    [super dealloc];
}

- (void)refreshUIForCurrentPost {
    if (self.apost.content != nil && [self.apost.content length] > 0){
        NSError *error;
        DDXMLDocument *xmlDocument = [[DDXMLDocument alloc] initWithXMLString:self.apost.content options:0 error:&error];
        [self extractPostCommentTemplateFromXMLDocument:xmlDocument];
        /*postCommentsTemplate= [self extractPostCommentTemplateFromXMLDocument:xmlDocument];
        if (postCommentsTemplate != nil){
            self.apost.content = postCommentsTemplate;
        }*/
        [self extractPostMediaHtmlListFromXMLDocument:xmlDocument];
        NSString* postText = [self extractPostTextFromXMLDocument:xmlDocument];
        if (postText != nil){
            self.apost.content = postText;
        }
        [xmlDocument release];
    }
    [super refreshUIForCurrentPost];
}

-(void)extractPostMediaHtmlListFromXMLDocument:(DDXMLDocument*)xmlDocument{
    NSError *error;
    NSArray* nodes = [xmlDocument nodesForXPath:@"//div[@id=\"post_media\"]" error:&error];
    if ([nodes count] > 0){
        DDXMLNode* mediaDiv = [nodes objectAtIndex:0];
        NSArray* linkNodes = [mediaDiv nodesForXPath:@"a | video" error:&error];
        for (DDXMLNode* linkNode in linkNodes){
            [self.mediaHtmlList addObject:[linkNode XMLString]];
        }
    }
}

/*-(void)extractPostCommentTemplateFromXMLDocument:(DDXMLDocument*)xmlDocument{
    NSError *error;
    NSArray* nodes = [xmlDocument nodesForXPath:@"//div[@id=\"artmaps-post-body\"]" error:&error];
    if ([nodes count] > 0){
        self.postCommentsTemplate = [[nodes objectAtIndex:0] XMLString];
    }
}*/

-(void)extractPostCommentTemplateFromXMLDocument:(DDXMLDocument*)xmlDocument{
    NSError *error;
    //    DDXMLElement *imageElement = [[itemElement nodesForXPath:@"image" error:&error] objectAtIndex:0];
    NSArray* nodes = [[xmlDocument nodesForXPath:@"//div[@id=\"artmaps-data-section\"]" error:&error] objectAtIndex:0];
    if ([nodes count] > 0){
        self.postCommentsTemplate = [[nodes objectAtIndex:0] XMLString];
    }
}

/*-(NSString*)extractPostCommentTemplateFromXMLDocument:(DDXMLDocument*)xmlDocument{
    NSError *error;
    NSArray* nodes = [xmlDocument nodesForXPath:@"//div[@id=\"artmaps-post-body\"]" error:&error];
    if ([nodes count] > 0){
        postCommentsTemplate = [[nodes objectAtIndex:0] XMLString];
    }
    return postCommentsTemplate;
}*/

-(NSString*)extractPostTextFromXMLDocument:(DDXMLDocument*)xmlDocument{
    NSString* postText = nil;
    NSError *error;
    NSArray* nodes = [xmlDocument nodesForXPath:@"//div[@id=\"post_text\"]" error:&error];
    if ([nodes count] > 0){
        postText = [[nodes objectAtIndex:0] stringValue];
    }
    return postText;
}

-(void)downloadPostCommentTemplateForOoi{
    NSString* apiUrl = [[[ExperienceConfigurer sharedInstance] currentExperience] getApiUrl];
    xmlRpcClient = [[AFXMLRPCClient alloc] initWithXMLRPCEndpoint:[NSURL URLWithString:apiUrl]];
    AFXMLRPCRequest *request = [self getPostCommentsTemplateRPCRequest];
    AFXMLRPCRequestOperation *operation = [self getPostCommentsTemplateRPCRequestOperationForClient:self.xmlRpcClient rpcRequest:request];
    [self.xmlRpcClient enqueueXMLRPCRequestOperation:operation];
}

-(NSArray*)getCommentTemplatesRPCReuqestParameter{
    NSMutableArray *parameters = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    NSNumber *objectOfInterestID = [[NSNumber alloc] initWithInt:self.ooiID];
    [parameters addObject:objectOfInterestID];
    [objectOfInterestID release];
    return parameters;
}

-(AFXMLRPCRequest*)getPostCommentsTemplateRPCRequest{
    NSArray* parameters = [self getCommentTemplatesRPCReuqestParameter];
    NSString* rpcMethodName = [[[ExperienceConfigurer sharedInstance] currentExperience] postCommentsTemplateRPCMethodName];
    AFXMLRPCRequest *request = [self.xmlRpcClient XMLRPCRequestWithMethod:rpcMethodName parameters:parameters];
    return request;
}

-(AFXMLRPCRequestOperation*)getPostCommentsTemplateRPCRequestOperationForClient:(AFXMLRPCClient*)rpcClient rpcRequest:(AFXMLRPCRequest*)request{
    
    MAZeroingWeakRef *selfweakRef = [MAZeroingWeakRef refWithTarget:self];
    
    AFXMLRPCRequestOperation *operation = [self.xmlRpcClient XMLRPCRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        CXMLDocument *xmlParser = [[CXMLDocument alloc] initWithXMLString:responseObject options:0 error:&error];
        [[selfweakRef target] setPostCommentsTemplate:xmlParser.XMLString];
        /*
        CXMLNode* linkNode = [xmlParser nodeForXPath:@"//a" error:&error];
        
        if ([linkNode kind] == CXMLElementKind){
            CXMLElement* element = (CXMLElement*) linkNode;
            CXMLNode* hrefNode = [element attributeForName:@"href"];
            if (hrefNode != nil){
                CXMLNode* urlAttributeNode = [hrefNode childAtIndex:0];
                NSString* url = [urlAttributeNode stringValue];
                url = [url stringByAppendingFormat:@"%d/",[[selfweakRef target] ooiID]];
                [urlAttributeNode setStringValue:url];
                [[selfweakRef target] setPostCommentsTemplate:xmlParser.XMLString];
            }
        }*/
        [xmlParser release];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[selfweakRef target] displayConnectionError];
            
        });
        WPFLog(@"Error getting template for post comments: %@", [error localizedDescription]);
    }];
    
    return operation;
}

/*-(void)displayError{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:@"Error for post comments." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}*/

-(void)displayConnectionError{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:@"Your connection appears to be offline." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)savePost:(BOOL)upload{
    NSString* postContent = [self preparePostContent];
    if (postContent){
        //self.apost.postTitle = titleTextField.text;
        self.apost.content = postContent;
        [super savePost:upload];
    }else{
        [self displayConnectionError];
    }
}
/*- (void)savePost:(BOOL)upload{
 self.apost.postTitle = titleTextField.text;
    NSString* postContent = [self preparePostContent];
    if (postContent){
        //self.apost.postTitle = titleTextField.text;
        //self.apost.content = postContent;
        self.apost.content = textView.text;
        [super savePost:upload];
    }else{
        [self displayConnectionError];
    }
 //Horizon code
 //self.apost.content = textView.text;
 if ([self.apost.content rangeOfString:@"<!--more-->"].location != NSNotFound)
 self.apost.mt_text_more = @"";
 
 [self.view endEditing:YES];
 
 if ( self.apost.original.password != nil ) { //original post was password protected
 if ( self.apost.password == nil || [self.apost.password isEqualToString:@""] ) { //removed the password
 self.apost.password = @"";
 }
 }
 
 [self.apost.original applyRevision];
 if (upload){
 NSString *postTitle = self.apost.postTitle;
 [self.apost.original uploadWithSuccess:^{
 NSLog(@"post uploaded: %@", postTitle);
 } failure:^(NSError *error) {
 NSLog(@"post failed: %@", [error localizedDescription]);
 }];
 } else {
 [self.apost.original save];
 }
 
 [self dismissEditView];
 }*/

//check if there are media in uploading status
/*-(BOOL) isMediaInUploading {
	
	BOOL isMediaInUploading = NO;
	
	NSSet *mediaFiles = self.apost.media;
	for (Media *media in mediaFiles) {
		if(media.remoteStatus == MediaRemoteStatusPushing) {
			isMediaInUploading = YES;
			break;
		}
	}
	mediaFiles = nil;
    
	return isMediaInUploading;
}

-(void) showMediaInUploadingalert {
	//the post is using the network connection and cannot be stoped, show a message to the user
	UIAlertView *blogIsCurrentlyBusy = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", @"Info alert title")
																  message:NSLocalizedString(@"A Media file is currently uploading. Please try later.", @"")
																 delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
	[blogIsCurrentlyBusy show];
	[blogIsCurrentlyBusy release];
}

- (IBAction)saveAction:(id)sender {
	if( [self isMediaInUploading] ) {
		[self showMediaInUploadingalert];
		return;
	}
	[self savePost:YES];
}*/

/*- (void)savePost:(BOOL)upload{
	self.apost.postTitle = titleTextField.text;
    //Horizon code
    //self.apost.content = textView.text;
	if ([self.apost.content rangeOfString:@"<!--more-->"].location != NSNotFound)
		self.apost.mt_text_more = @"";
    
    [self.view endEditing:YES];
    
    if ( self.apost.original.password != nil ) { //original post was password protected
        if ( self.apost.password == nil || [self.apost.password isEqualToString:@""] ) { //removed the password
            self.apost.password = @"";
        }
    }
    
    [self.apost.original applyRevision];
	if (upload){
		NSString *postTitle = self.apost.postTitle;
        [self.apost.original uploadWithSuccess:^{
            NSLog(@"post uploaded: %@", postTitle);
        } failure:^(NSError *error) {
            NSLog(@"post failed: %@", [error localizedDescription]);
        }];
	} else {
		[self.apost.original save];
	}
    
    [self dismissEditView];
}*/

/*-(NSString*)preparePostContent{
    NSString *postContent = nil;
    if (self.postCommentsTemplate != NULL){
        postContent = @"<div id=\"artmaps-post-body\">";
        postContent = [postContent stringByAppendingString:self.postCommentsTemplate];
        //postContent = [postContent stringByAppendingString:[self getPostCommentsHTML]];
        postContent = [postContent stringByAppendingString:@"\n"];
        postContent = [postContent stringByAppendingString:@"<div id=\"post_text\">"];
        postContent = [postContent stringByAppendingString:textView.text];
        postContent = [postContent stringByAppendingString:@"</div>"];
        postContent = [postContent stringByAppendingString:[self getPostMediaHTML]];
        postContent = [postContent stringByAppendingString:@"</div>"];
        postContent = [postContent stringByAppendingString:@"</div>"];
        
    }
    return postContent;
}*/


-(NSString*)preparePostContent{
    NSString *postContent = nil;
    if (self.postCommentsTemplate != NULL){
        postContent = @"<div id=\"post_template\">";
        postContent = [postContent stringByAppendingString:self.postCommentsTemplate];
        postContent = [postContent stringByAppendingString:@"\n"];
        postContent = [postContent stringByAppendingString:@"<div id=\"post_text\">"];
        postContent = [postContent stringByAppendingString:textView.text];
        postContent = [postContent stringByAppendingString:@"</div>"];
        postContent = [postContent stringByAppendingString:[self getPostMediaHTML]];
        postContent = [postContent stringByAppendingString:@"</div>"];
        postContent = [postContent stringByAppendingString:@"</div>"];
    }
    return postContent;
}

/*-(NSString*)preparePostContent{
    NSString *postContent = nil;
    if (self.postCommentsTemplate != NULL){
        postContent = @"<div id=\"post_template\">";
        postContent = [postContent stringByAppendingString:self.postCommentsTemplate];
        postContent = [postContent stringByAppendingString:@"\n"];
        postContent = [postContent stringByAppendingString:@"<div id=\"post_text\">"];
        postContent = [postContent stringByAppendingString:textView.text];
        postContent = [postContent stringByAppendingString:@"</div>"];
        postContent = [postContent stringByAppendingString:[self getPostMediaHTML]];
        postContent = [postContent stringByAppendingString:@"</div>"];
        postContent = [postContent stringByAppendingString:@"</div>"];
    }
    return postContent;
}*/

-(NSString*)getPostMediaHTML{
    NSString *mediaTemplate = @"";
    mediaTemplate = @"<div id=\"post_media\">";
    for (NSString* html in self.mediaHtmlList){
        mediaTemplate = [mediaTemplate stringByAppendingString:@"<br/>"];
        mediaTemplate = [mediaTemplate stringByAppendingString:html];
    }
    mediaTemplate = [mediaTemplate stringByAppendingString:@"</div>"];
    return mediaTemplate;
}

/*-(NSString*)getPostCommentsHTML{
    //NSString *artmapsTemplate = @"";
    self.postCommentsTemplate = @"<div id=\"artmaps-post-body\">";
    for (NSString* html in self.postCommentsTemplate){
        //NSArray* nodes = [xmlDocument nodesForXPath:@"//div[@id=\"artmaps-post-body\"]" error:&error];
        //if ([nodes count] > 0){
        //    self.postCommentsTemplate = [[nodes objectAtIndex:0] XMLString];
        //}
        self.postCommentsTemplate = [self.postCommentsTemplate stringByAppendingString:html];
    }
    self.postCommentsTemplate = [self.postCommentsTemplate stringByAppendingString:@"\n"];
    self.postCommentsTemplate = [self.postCommentsTemplate stringByAppendingString:@"<div id=\"post_text\">"];
    self.postCommentsTemplate = [self.postCommentsTemplate stringByAppendingString:textView.text];
    self.postCommentsTemplate = [self.postCommentsTemplate stringByAppendingString:@"</div>"];
    self.postCommentsTemplate = [self.postCommentsTemplate stringByAppendingString:[self getPostMediaHTML]];
    self.postCommentsTemplate = [self.postCommentsTemplate stringByAppendingString:@"</div>"];
    return postCommentsTemplate;
}*/


//insert media.
-(void)insertMediaInMediaTemplate:(Media*)media{
    NSString* mediaHtml = media.html;
    NSInteger mediaIndex = [self getMediaHtmlIndex:mediaHtml InMediaHtmlList:self.mediaHtmlList];
    if (mediaIndex == MEDIA_NOT_FOUND)
        [self.mediaHtmlList addObject:mediaHtml];
}

-(NSInteger)getMediaHtmlIndex:(NSString*)mediaHtml InMediaHtmlList:(NSArray*)mediaList{
    NSInteger mediaIndex = MEDIA_NOT_FOUND;
    NSString* tmpMediaHtml = [mediaHtml stringByReplacingOccurrencesOfString:@" " withString:@""];
    for ( int i = 0; i < [mediaList count]; i++ ){
        NSString* html = [mediaHtmlList objectAtIndex:i];
        html = [html stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([tmpMediaHtml rangeOfString:html options:NSCaseInsensitiveSearch].length > 0){
            mediaIndex = i;
            break;
        }
    }
    return mediaIndex;
}

-(void)addMedia:(NSNotification *)notification{
   Media *media = (Media *)[notification object];
   [self insertMediaInMediaTemplate:media];
}

- (void)insertMediaAbove:(NSNotification *)notification {
    //horizon test
    [self addMedia:notification];
}

- (void)insertMediaBelow:(NSNotification *)notification {
    [self addMedia:notification];
}

- (void)removeMedia:(NSNotification *)notification {
	//remove the html string for the media object
	Media *media = (Media *)[notification object];
    NSString* mediaHtml = media.html;
    NSInteger mediaIndex = [self getMediaHtmlIndex:mediaHtml InMediaHtmlList:self.mediaHtmlList];
    if (mediaIndex != MEDIA_NOT_FOUND){
        [self.mediaHtmlList removeObjectAtIndex:mediaIndex];
    }
}

/*- (void)insertMediaAbove:(NSNotification *)notification {
	Media *media = (Media *)[notification object];
	NSString *prefix = @"<br /><br />";
	
	if(self.apost.content == nil || [self.apost.content isEqualToString:@""]) {
		self.apost.content = @"";
		prefix = @"";
	}
	
	NSMutableString *content = [[[NSMutableString alloc] initWithString:media.html] autorelease];
	NSRange imgHTML = [textView.text rangeOfString: content];
	
	NSRange imgHTMLPre = [textView.text rangeOfString:[NSString stringWithFormat:@"%@%@", @"<br /><br />", content]];
 	NSRange imgHTMLPost = [textView.text rangeOfString:[NSString stringWithFormat:@"%@%@", content, @"<br /><br />"]];
	
	if (imgHTMLPre.location == NSNotFound && imgHTMLPost.location == NSNotFound && imgHTML.location == NSNotFound) {
		[content appendString:[NSString stringWithFormat:@"%@%@", prefix, self.apost.content]];
        self.apost.content = content;
	}
	else {
		NSMutableString *processedText = [[[NSMutableString alloc] initWithString:textView.text] autorelease];
		if (imgHTMLPre.location != NSNotFound)
			[processedText replaceCharactersInRange:imgHTMLPre withString:@""];
		else if (imgHTMLPost.location != NSNotFound)
			[processedText replaceCharactersInRange:imgHTMLPost withString:@""];
		else
			[processedText replaceCharactersInRange:imgHTML withString:@""];
        
		[content appendString:[NSString stringWithFormat:@"<br /><br />%@", processedText]];
		self.apost.content = content;
	}
    [self refreshUIForCurrentPost];
}

- (void)insertMediaBelow:(NSNotification *)notification {
	Media *media = (Media *)[notification object];
	NSString *prefix = @"<br /><br />";
	
	if(self.apost.content == nil || [self.apost.content isEqualToString:@""]) {
		self.apost.content = @"";
		prefix = @"";
	}
	
	NSMutableString *content = [[[NSMutableString alloc] initWithString:self.apost.content] autorelease];
	NSRange imgHTML = [content rangeOfString: media.html];
	NSRange imgHTMLPre = [content rangeOfString:[NSString stringWithFormat:@"%@%@", @"<br /><br />", media.html]];
 	NSRange imgHTMLPost = [content rangeOfString:[NSString stringWithFormat:@"%@%@", media.html, @"<br /><br />"]];
	
	if (imgHTMLPre.location == NSNotFound && imgHTMLPost.location == NSNotFound && imgHTML.location == NSNotFound) {
		[content appendString:[NSString stringWithFormat:@"%@%@", prefix, media.html]];
        self.apost.content = content;
	}
	else {
		if (imgHTMLPre.location != NSNotFound)
			[content replaceCharactersInRange:imgHTMLPre withString:@""];
		else if (imgHTMLPost.location != NSNotFound)
			[content replaceCharactersInRange:imgHTMLPost withString:@""];
		else
			[content replaceCharactersInRange:imgHTML withString:@""];
		[content appendString:[NSString stringWithFormat:@"<br /><br />%@", media.html]];
		self.apost.content = content;
	}
    [self refreshUIForCurrentPost];
}

- (void)removeMedia:(NSNotification *)notification {
	//remove the html string for the media object
	Media *media = (Media *)[notification object];
	textView.text = [textView.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<br /><br />%@", media.html] withString:@""];
	textView.text = [textView.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@<br /><br />", media.html] withString:@""];
	textView.text = [textView.text stringByReplacingOccurrencesOfString:media.html withString:@""];
	self.apost.content = textView.text;
}*/

- (CGRect)normalTextFrame {
    if (IS_IPAD) {
        if ((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft)
            || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)) // Landscape
            return CGRectMake(0, 143, self.view.bounds.size.width, 517);
        else // Portrait
            return CGRectMake(0, 143, self.view.bounds.size.width, 753);
    } else {
        //CGFloat y = 136.f;
        //horizon code
        CGFloat y = 45.f;
        CGFloat height = self.toolbar.frame.origin.y - y;
        if ((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft)
            || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)) // Landscape
			return CGRectMake(0, y, self.view.bounds.size.width, height);
		else // Portrait
			return CGRectMake(0, y, self.view.bounds.size.width, height);
    }
}


@end
