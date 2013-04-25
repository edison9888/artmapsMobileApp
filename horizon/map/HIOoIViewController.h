//
//  HIPOIViewController.h
//  WordPress
//
//  Created by Shakir Ali on 11/07/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "REVClusterMap.h"
#import "OoISearchLoader.h"
#import "ObjectOfInterest.h"
#import "OoIMetaLoader.h"
#import "PostMapLocation.h"
#import "MetaTableViewController.h"
#import "MetaDataGLAViewController.h"
#import "Blog.h"


@interface HIOoIViewController : UIViewController <OoISearchLoaderDelegate, MKMapViewDelegate, CLLocationManagerDelegate, OoIMetaLoaderDelegate>{
    //ObjectOfInterest* newObjectOfInterest;
}

@property (nonatomic, retain) IBOutlet REVClusterMapView *mapViewControl;
@property (nonatomic, retain) NSMutableArray* existingObjectOfInterests;
@property (nonatomic, retain) Blog *blog;

@end
