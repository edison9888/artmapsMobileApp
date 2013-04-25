//
//  HIEditPostViewController.h
//  WordPress
//
//  Created by horizon on 28/09/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "EditPostViewController.h"

@class PostMapLocation;
@class OoIMeta;
@class OoIMetaGLA;

@interface HIEditPostViewController : EditPostViewController


@property (nonatomic, retain) PostMapLocation *postMapLocation;
@property (nonatomic, retain) OoIMeta *ooiMeta;
@property (nonatomic, retain) OoIMetaGLA *ooiMetaGLA;
@property int ooiID;
@property (nonatomic, retain) NSString* postCommentsTemplate;
//@property (nonatomic, retain) NSString* preparePostCommentsTemplate;
@property (nonatomic, retain) NSOperation *postCommentOperation;
@property (nonatomic,retain) AFXMLRPCClient *xmlRpcClient;

@property (nonatomic, assign) HIEditPostViewController *postDetailViewController;

//override function.
- (id)initWithPost:(AbstractPost *)aPost;
-(NSString*)preparePostContent;

// Media
- (void)insertMediaAbove:(NSNotification *)notification;
- (void)insertMediaBelow:(NSNotification *)notification;
- (void)removeMedia:(NSNotification *)notification;

@end
