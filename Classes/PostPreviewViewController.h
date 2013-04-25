#import <UIKit/UIKit.h>
#import "EditPostViewController.h"

//Horizon code
@class HIEditPostViewController;

@interface PostPreviewViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    UIView *loadingView;

    //Horizon code.
    EditPostViewController *postDetailViewController;
    //HIEditPostViewController *postDetailViewController;
	NSFetchedResultsController *resultsController;
	
	NSMutableData *receivedData;
}

//Horizon code
@property (nonatomic, assign) EditPostViewController *postDetailViewController;
//@property (nonatomic, assign) HIEditPostViewController *postDetailViewController;
@property (readonly) UIWebView *webView;

- (void)refreshWebView;

@end
