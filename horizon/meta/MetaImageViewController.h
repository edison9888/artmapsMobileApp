//
//  UIMetaImageViewControllerViewController.h
//  WordPress
//
//  Created by Shakir Ali on 10/08/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetaImageViewController : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *panRecognizer;

- (IBAction)handlePinchRecognizer:(UIPinchGestureRecognizer *)gestureRecognizer;
- (IBAction)handlePanRecognizer:(UIPanGestureRecognizer *)dragRecognizer;

@end
