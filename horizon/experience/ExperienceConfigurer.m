//
//  ExperienceConfigurer.m
//  WordPress
//
//  Created by Shakir Ali on 19/07/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "ExperienceConfigurer.h"
//#import "Blog.h"
#import "WordPressAppDelegate.h"

@implementation ExperienceConfigurer

@synthesize currentExperience;
@synthesize selectedBlog;

static ExperienceConfigurer *sharedInstance = nil;

+(ExperienceConfigurer*)sharedInstance{
    if (sharedInstance){
        return sharedInstance;
    }
    @synchronized(self)
    {
        if (sharedInstance == nil ){
            sharedInstance = [[ExperienceConfigurer alloc] init];
            //experiences = [[NSMutableArray alloc] initWithCapacity:0];
            //sharedInstance.currentExperience = [sharedInstance setSelectedExperience];
            [sharedInstance addRegisteredBlogExperiences];
            //sharedInstance.currentExperience = [experiences objectAtIndex:0];
        }
    }
    return sharedInstance;
}

-(void)dealloc{
    [currentExperience release];
    [selectedBlog release];
    [sharedInstance release];
    [experiences release];
    [super dealloc];
}

+(id)allocWithZone:(NSZone*)zone
{
	@synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil 
}

-(id)copyWithZone:(NSZone*)zone
{
	return self;
}

-(id)retain{
	return self;
}

-(NSUInteger)retainCount
{
	return NSUIntegerMax;
}

-(id)autorelease
{
	return self;
}

/*#pragma mark instance functions.
-(NSArray*)getRegisteredBlogExperiences{
    NSMutableArray *experiences = [[NSMutableArray alloc] initWithCapacity:0];
    BlogExperience *blogExperience = [[BlogExperience alloc] init];
    blogExperience.name = @"Tate";
    blogExperience.context=@"tate";
    blogExperience.iconPath=@"tate.png";
    blogExperience.baseUrl = @"http://tate.artmaps.wp.horizon.ac.uk";
    blogExperience.ooiBaseUrl = @"artwork";
    blogExperience.apiBaseUrl = @"xmlrpc.php";
    blogExperience.postCommentsTemplateRPCMethodName = @"artmaps.commentTemplate";
    [experiences addObject:blogExperience];
    [blogExperience release];
    return [experiences autorelease];
}*/

#pragma mark instance functions.
-(void)addRegisteredBlogExperiences{
    if (experiences == nil){
        experiences = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //if(blogExperience.experiences){
    //id delegate = [[UIApplication sharedApplication] delegate];
    WordPressAppDelegate *appDelegate = [WordPressAppDelegate sharedWordPressApp];
    experienceSelection = [appDelegate experienceSelection];
    //experienceSelection = (ExperienceSelection *)[delegate;
    //NSMutableArray *experiences = [[NSMutableArray alloc] initWithCapacity:0];
    
    //Tate
    BlogExperience *blogExperience = [[BlogExperience alloc] init];
    blogExperience = [[BlogExperience alloc] init];
    blogExperience.name = @"Tate";
    blogExperience.context=@"tate";
    blogExperience.iconPath=@"tate.png";
    //blogExperience.baseUrl = @"http://tate.artmaps.wp.horizon.ac.uk";
    //blogExperience.baseUrl = @"http://wp-artmaps.cloudapp.net/artmaps/tate/";
    //blogExperience.baseUrl = @"http://www.artmaps.org.uk/artmaps/tate2/";
    blogExperience.baseUrl = @"http://www.artmaps.org.uk/artmaps/tate/";
    blogExperience.ooiBaseUrl = @"artwork";
    blogExperience.apiBaseUrl = @"xmlrpc.php";
    blogExperience.postCommentsTemplateRPCMethodName = @"artmaps.commentTemplate";
    [experiences addObject:blogExperience];
    [blogExperience release];
    
    //GLA
    blogExperience = [[BlogExperience alloc] init];
    blogExperience.name = @"GLA";
    blogExperience.context=@"glatm";
    blogExperience.iconPath=@"tate.png";
    //blogExperience.baseUrl = @"http://tate.artmaps.wp.horizon.ac.uk";
    //blogExperience.ooiBaseUrl = @"artwork";
    //blogExperience.baseUrl = @"http://genderlatm.wp.horizon.ac.uk";
    //blogExperience.baseUrl = @"http://wp-artmaps.cloudapp.net/artmaps/glatm/";
    blogExperience.baseUrl = @"http://www.artmaps.org.uk/artmaps/glatm/";
    blogExperience.ooiBaseUrl = @"glatm";
    blogExperience.apiBaseUrl = @"xmlrpc.php";
    blogExperience.postCommentsTemplateRPCMethodName = @"artmaps.commentTemplate";
    [experiences addObject:blogExperience];
    [blogExperience release];

    sharedInstance.currentExperience = [experiences objectAtIndex:0];
}

-(void)setSelectedExperience:(NSString*)experienceName{
    for (BlogExperience* blogExperience in experiences){
        if([blogExperience.name compare:experienceName options: NSCaseInsensitiveSearch] == NSOrderedSame){
            self.currentExperience = blogExperience;
        }
    }
}

@end
