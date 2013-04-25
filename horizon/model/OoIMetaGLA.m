//
//  OoIMetaGLA.m
//  WordPress
//
//  Created by lavdrus on 29/11/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "OoIMetaGLA.h"

@implementation OoIMetaGLA

@synthesize allegiance;
@synthesize event;
@synthesize name;
@synthesize year;
//@synthesize reference;
//@synthesize title;

-(void)dealloc{
    [allegiance release];
    [event release];
    [name release];
    [year release];
    //[reference release];
    //[title release];
    [super dealloc];
}


@end
