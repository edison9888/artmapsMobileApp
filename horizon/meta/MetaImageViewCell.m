//
//  MetaImageViewCell.m
//  WordPress
//
//  Created by Shakir Ali on 08/08/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "MetaImageViewCell.h"

@implementation MetaImageViewCell

@synthesize imageView;
@synthesize spinner;
@synthesize artworkdateLabel;
@synthesize referenceLabel;
//@synthesize logoView;

-(void)dealloc{
    [imageView release];
    [spinner release];
    [artworkdateLabel release];
    [referenceLabel release];
    //[logoView release];
    [super dealloc];
}

@end
