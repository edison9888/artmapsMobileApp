//
//  ExperienceConfigurer.h
//  WordPress
//
//  Created by Shakir Ali on 19/07/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlogExperience.h"
#import "ExperienceSelection.h"

@class Blog;

@interface ExperienceConfigurer : NSObject{
    ExperienceSelection *experienceSelection;
    NSMutableArray* experiences;
}

+(ExperienceConfigurer*)sharedInstance;
@property (nonatomic, retain) BlogExperience* currentExperience;
@property (nonatomic, retain) Blog *selectedBlog;
//-(NSArray*)getRegisteredBlogExperiences;
-(void)addRegisteredBlogExperiences;
-(void)setSelectedExperience:(NSString*)experience;
@end
