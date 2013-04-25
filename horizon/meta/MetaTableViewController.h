//
//  MetaTableViewController.h
//  WordPress
//
//  Created by Shakir Ali on 26/07/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OoIMeta.h"
#import "ImageDownloader.h"

@class PostMapLocation;

@interface MetaTableViewController : UITableViewController <ImageDownloaderDelegate>

typedef enum{
    kArtist = 0,
    kImageUrl,
    kTitle,
    NO_OF_SECTIONS
} metasections;

@property int ooiID;
@property (nonatomic, retain) OoIMeta *ooiMeta;
@property (nonatomic, retain) PostMapLocation *postMapLocation;

@end