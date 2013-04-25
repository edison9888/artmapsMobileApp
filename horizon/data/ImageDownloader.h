//
//  ImageDownloader.h
//  WordPress
//
//  Created by Shakir Ali on 08/08/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "DataLoader.h"

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : DataLoader{
    id<ImageDownloaderDelegate> imageDelegate;
}
@property (nonatomic, assign) id<ImageDownloaderDelegate> delegate;
@property (nonatomic, retain) UIImage* image;

-(id)initWithImageURL:(NSString*)url;
//-(void)submitImageURL:(NSString*)imageURL;
@end

@protocol ImageDownloaderDelegate <NSObject>
@optional
-(void)imageDownloader:(ImageDownloader*)imageDownloader didLoadImage:(UIImage*)image;
-(void)imageDownloader:(ImageDownloader *)imageDownloader didFailWithError:(NSError*)error;
@end