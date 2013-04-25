//
//  BlogExperience.h
//  WordPress
//
//  Created by Shakir Ali on 19/07/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ExperienceViewController.h"
#import "ExperienceSelection.h"


@interface BlogExperience : NSObject{
    ExperienceSelection *experienceSelection;
}


@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* context;
@property (nonatomic, retain) NSString* iconPath;
@property (nonatomic, retain) NSString* baseUrl;
@property (nonatomic, retain) NSString* ooiBaseUrl;
@property (nonatomic, retain) NSString* apiBaseUrl;
@property (nonatomic, retain) NSString* postCommentsTemplateRPCMethodName;
//@property (nonatomic, retain) ExperienceViewController* experienceViewController;
//@property (nonatomic, retain) NSString* experience;

-(NSString*)getTitleForOoIList;
-(NSString*)getTitleForOoI;
-(NSString*)geturlForOoi:(NSString*)ooiID;
-(NSString*)getApiUrl;
-(NSString*)getExperience;
@end
