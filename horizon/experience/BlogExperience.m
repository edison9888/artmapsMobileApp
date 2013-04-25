//
//  BlogExperience.m
//  WordPress
//
//  Created by Shakir Ali on 19/07/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "BlogExperience.h"
#import "WordPressAppDelegate.h"

@implementation BlogExperience

@synthesize name;
@synthesize context;
@synthesize iconPath;
@synthesize baseUrl;
@synthesize ooiBaseUrl;
@synthesize apiBaseUrl;
@synthesize postCommentsTemplateRPCMethodName;
//@synthesize experienceViewController;

-(NSString*)getTitleForOoIList{
    //ExperienceViewController *blogExperience = [[ExperienceViewController alloc] init];
    //id delegate = [[UIApplication sharedApplication] delegate];
    //experienceSelection = (ExperienceSelection *)[delegate experienceSelection];
    WordPressAppDelegate *appDelegate = [WordPressAppDelegate sharedWordPressApp];
    experienceSelection = [appDelegate experienceSelection];
    if(experienceSelection.selectedExperience == @"gla"){
        return NSLocalizedString(@"Gender L. America", nil);
    }else{
        return NSLocalizedString(@"TATE - Art Maps", nil);
    }
}

-(NSString*)getTitleForOoI{
    //id delegate = [[UIApplication sharedApplication] delegate];
    //experienceSelection = (ExperienceSelection *)[delegate experienceSelection];
    WordPressAppDelegate *appDelegate = [WordPressAppDelegate sharedWordPressApp];
    experienceSelection = [appDelegate experienceSelection];
    if(experienceSelection.selectedExperience == @"gla"){
        return NSLocalizedString(@"Gender L. America", nil);
    }else{
        return NSLocalizedString(@"TATE - Art Maps", nil);
    }

}

-(NSString*)getExperience{
    //id delegate = [[UIApplication sharedApplication] delegate];
    //experienceSelection = (ExperienceSelection *)[delegate experienceSelection];
    WordPressAppDelegate *appDelegate = [WordPressAppDelegate sharedWordPressApp];
    experienceSelection = [appDelegate experienceSelection];
    if(experienceSelection.selectedExperience == @"gla"){
        return NSLocalizedString(@"glatm", nil);
    }else{
        return NSLocalizedString(@"tate", nil);
    }
    
}


-(NSString*)geturlForOoi:(NSString*) ooiID{
    return [NSString stringWithFormat:@"%@/%@/%@/", baseUrl, ooiBaseUrl, ooiID];
}

-(NSString*)getApiUrl{
    return [NSString stringWithFormat:@"%@/%@", baseUrl, apiBaseUrl];
}

-(void)dealloc{
    [name release];
    [context release];
    [iconPath release];
    [ooiBaseUrl release];
    [baseUrl release];
    [apiBaseUrl release];
    [postCommentsTemplateRPCMethodName release];
    [experienceSelection release];
    [super dealloc];
}

@end
