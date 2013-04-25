//
//  MetaImageViewCell.h
//  WordPress
//
//  Created by Shakir Ali on 08/08/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetaImageViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *artworkdateLabel;
@property (nonatomic, retain) IBOutlet UILabel *referenceLabel;
//@property (nonatomic, retain) IBOutlet UIImageView *logoView;
@end
