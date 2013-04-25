//
//  MetaDataGLAViewController.h
//  WordPress
//
//  Created by lavdrus on 29/11/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OoIMetaGLA.h"
//#import "ImageDownloader.h"

@class PostMapLocation;

@interface MetaDataGLAViewController : UITableViewController

typedef enum{
    kAllegiance = 0,
    kEvent,
    kName,
    kYear,
    NO_OF_GLASECTIONS
} metaGLAsections;

@property int ooiID;
@property (nonatomic, retain) OoIMetaGLA *ooiMeta;
@property (nonatomic, retain) PostMapLocation *postMapLocation;

@end
