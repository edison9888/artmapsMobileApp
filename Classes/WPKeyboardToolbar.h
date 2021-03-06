//
//  WPKeyboardToolbar.h
//  WordPress
//
//  Created by Jorge Bernal on 8/11/11.
//  Copyright 2011 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WPKeyboardToolbarButtonItem.h"

#define WPKT_HEIGHT_IPHONE_PORTRAIT 42.0f
#define WPKT_HEIGHT_IPHONE_LANDSCAPE 33.0f
#define WPKT_HEIGHT_IPAD_PORTRAIT 65.0f
#define WPKT_HEIGHT_IPAD_LANDSCAPE 65.0f

@protocol WPKeyboardToolbarDelegate <NSObject>
- (void)keyboardToolbarButtonItemPressed:(WPKeyboardToolbarButtonItem *)buttonItem;
@end

@interface WPKeyboardToolbar : UIView<UIInputViewAudioFeedback> {
    CAGradientLayer *_gradient;
    UIView *mainView, *extendedView;
    WPKeyboardToolbarButtonItem *boldButton, *italicsButton, *linkButton, *quoteButton, *delButton;
    WPKeyboardToolbarButtonItem *ulButton, *olButton, *liButton, *codeButton, *moreButton;
    WPKeyboardToolbarButtonItem *doneButton, *toggleButton;
}
@property (nonatomic, assign) id<WPKeyboardToolbarDelegate> delegate;
@property (nonatomic, retain) WPKeyboardToolbarButtonItem *doneButton;

@end
