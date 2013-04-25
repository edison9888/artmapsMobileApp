//
//  ImageDownloader.m
//  WordPress
//
//  Created by Shakir Ali on 08/08/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader (){
    BOOL downloading;
}
@property (nonatomic,retain) NSURL *imageURL;
@end

@implementation ImageDownloader

@synthesize delegate;
@synthesize imageURL;
@synthesize image;

-(id)initWithImageURL:(NSString*)url{
    self = [super init];
    if (self){
        imageURL = [[NSURL alloc] initWithString:url];
        downloading = NO;
    }
    return self;
}

-(UIImage*)image{
    if (image == nil && !downloading){
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];
        [self submitURLRequest:urlRequest];
        downloading = YES;
    }
    return image;
}

/*
-(void)submitImageURL:(NSString*)url{
    self.imageURL = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];
    [self submitURLRequest:urlRequest];
}
*/

-(void)dealloc{
    [delegate release];
    [imageURL release];
    [image release];
    [super dealloc];
}

#pragma mark NSURLConnectionDelegate functions.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    downloading = NO;
    self.image = [UIImage imageWithData:self.downloadedData];
    if ([self.delegate respondsToSelector:@selector(imageDownloader:didLoadImage:)]){
        [self.delegate imageDownloader:self didLoadImage:image];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    downloading = NO;
    [super connection:connection didFailWithError:error];
    if ([self.delegate respondsToSelector:@selector(imageDownloader:didFailWithError:)]){
        [self.delegate imageDownloader:self didFailWithError:error];
    }
}

-(void)cancelImageDownload{
    [self cancelRequest];
    self.delegate = nil;
    downloading = NO;
    self.image = nil;
}


@end
