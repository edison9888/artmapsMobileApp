//
//  HIPostPreviewViewController.m
//  WordPress
//
//  Created by horizon on 10/10/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "HIPostPreviewViewController.h"

@interface HIPostPreviewViewController ()

@end

@implementation HIPostPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshWebView {
    [webView loadHTMLString:[self buildSimplePreview] baseURL:nil];
}

- (NSString *)buildSimplePreview {
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *fpath = [NSString stringWithFormat:@"%@/defaultPostTemplate.html", resourcePath];
	NSString *str = [NSString stringWithContentsOfFile:fpath encoding:NSUTF8StringEncoding error:nil];
	
	if ([str length]) {
		
		//Title
		NSString *title = self.postDetailViewController.apost.postTitle;
		title = (title == nil || ([title length] == 0) ? NSLocalizedString(@"(no title)", @"") : title);
		str = [str stringByReplacingOccurrencesOfString:@"!$title$!" withString:title];
		
		//Content
        //Horizon code
        //NSString *desc = postDetailViewController.apost.content;
        HIEditPostViewController *editPostViewController = (HIEditPostViewController*)self.postDetailViewController;
        NSString *desc = [ editPostViewController preparePostContent];
		if (!desc){
			desc = [NSString stringWithFormat:@"<h1>%@</h1>", NSLocalizedString(@"No Description available for this Post", @"")];
        }
        /*
        else {
            desc = [self stringReplacingNewlinesWithBR:desc];
        }*/
		desc = [NSString stringWithFormat:@"<p>%@</p><br />", desc];
		str = [str stringByReplacingOccurrencesOfString:@"!$text$!" withString:desc];
		str = [str stringByReplacingOccurrencesOfString:@"!$mt_keywords$!" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"!$categories$!" withString:@""];
        
   	} else {
		str = @"";
	}
    return str;
}

- (NSString *)stringReplacingNewlinesWithBR:(NSString *)surString {
    NSArray *comps = [surString componentsSeparatedByString:@"\n"];
    return [comps componentsJoinedByString:@"<br>"];
}



@end
