//
//  OoIMetaLoader.m
//  WordPress
//
//  Created by Shakir Ali on 21/07/2012.
//  Copyright (c) 2012 WordPress. All rights reserved.
//
#import "JSONKit.h"

#import "OoIMetaLoader.h"
#import "RestAPIConnector.h"
#import "DataParser.h"
#import "ExperienceConfigurer.h"

@implementation OoIMetaLoader
@synthesize delegate;
@synthesize refObjID;
@synthesize indexPathInTableView;

const NSInteger EMPTY_DATA_RETURNED = 1;

-(void)submitOoIMetaRequestWithID:(NSNumber*)metaID{
    [self initConnectionRequest];
    NSURLRequest* urlRequest = [self prepareOoIMetaRequestWithID:metaID];
    [self submitURLRequest:urlRequest];
}

-(void)submitOoIMetaRequestWithID:(NSNumber*)metaID forIndexPathInTableView:(NSIndexPath*)indexPath{
    self.indexPathInTableView = indexPath;
    [self submitOoIMetaRequestWithID:metaID];
}

-(NSURLRequest*)prepareOoIMetaRequestWithID:(NSNumber*)metaID{
    NSString* metaUrl = [[RestAPIConnector sharedInstance] getOoIMetaURLWithMetaID:metaID];
    NSURL* url = [NSURL URLWithString:metaUrl];
    return [NSURLRequest requestWithURL:url];
}

#pragma mark NSURLConnectionDelegate functions.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [super connectionDidFinishLoading:connection];
    if (self.downloadedData.length > 0){
        NSError* error;
        NSDictionary *data= [self.downloadedData objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&error];
        if (data != nil){
            NSString* title = [[[ExperienceConfigurer sharedInstance] currentExperience] getTitleForOoIList];
            if(title == @"TATE - Art Maps"){
                OoIMeta* ooiMeta = [DataParser getOoIMetaFromDictionary:data];
                if (self.indexPathInTableView == nil){
                    if ([self.delegate respondsToSelector:@selector(OoIMetaLoader:didLoadOoIMeta:)])
                        [delegate OoIMetaLoader:self didLoadOoIMeta:ooiMeta];
                }
                else{
                    if ([self.delegate respondsToSelector:@selector(metaDataDidLoad:forIndexPath:)])
                        [delegate metaDataDidLoad:ooiMeta forIndexPath:indexPathInTableView];
                }
            }else if(title == @"Gender L. America"){
                OoIMetaGLA* ooiMetaGLA = [DataParser getOoIMetaGLAFromDictionary:data];
                if (self.indexPathInTableView == nil){
                    if ([self.delegate respondsToSelector:@selector(OoIMetaLoader:didLoadOoIMetaGLA:)])
                        [delegate OoIMetaLoader:self didLoadOoIMetaGLA:ooiMetaGLA];
                }
                else{
                    if ([self.delegate respondsToSelector:@selector(metaDataDidLoadGLA:forIndexPath:)])
                        [delegate metaDataDidLoadGLA:ooiMetaGLA forIndexPath:indexPathInTableView];
                }
            }
            /*if (self.indexPathInTableView == nil){
                if ([self.delegate respondsToSelector:@selector(OoIMetaLoader:didLoadOoIMeta:)])
                    [delegate OoIMetaLoader:self didLoadOoIMeta:ooiMeta];
            }
            else{
                if ([self.delegate respondsToSelector:@selector(metaDataDidLoad:forIndexPath:)])
                    [delegate metaDataDidLoad:ooiMeta forIndexPath:indexPathInTableView];
            }*/
        }else{
             [self reportErrorToDelegate:error];
        }
    }else{
        [self downloadErrorWithErrorCode:EMPTY_DATA_RETURNED ForConnection:connection];
    }
}

-(void)reportErrorToDelegate:(NSError*)error{
    if ([self.delegate respondsToSelector:@selector(OoIMetaLoader:didFailWithError:)])
        [delegate OoIMetaLoader:self didFailWithError:error];
}

-(void)downloadErrorWithErrorCode:(NSInteger)errorCode ForConnection:(NSURLConnection*) connection{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Application cannot download data. Please check your internet connection."
                                                         forKey:NSLocalizedDescriptionKey];
    NSError *error = [[NSError alloc] initWithDomain:@"" code:errorCode userInfo:userInfo];
    [self reportErrorToDelegate:error];
    [error release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [super connection:connection didFailWithError:error];
    [self reportErrorToDelegate:error];
}

-(void)cancelMetaLoad{
    [self cancelRequest];
    self.delegate = nil;
}

-(void)dealloc{
    delegate = nil;
    [refObjID release];
    [indexPathInTableView release];
    [super dealloc];
}

@end
