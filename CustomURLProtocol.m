//
//  CustomURLProtocol.m
//  NSURLProtocolExample
//
//  Created by lujb on 15/6/15.
//  Copyright (c) 2015年 lujb. All rights reserved.
//

#import "CustomURLProtocol.h"
#import "MJExtension.h"
static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface CustomURLProtocol ()<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation CustomURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //Handle HTTP and HTTPS requests.
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //To prevent the circulation
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
   
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    //To prevent the circulation
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
}

- (void)stopLoading
{
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
   
    NSString * body = [[ NSString alloc] initWithData:mutableReqeust.HTTPBody encoding:NSUTF8StringEncoding];
    
    NSString *datastr = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Check network request. --- URL:%@, HTTPMethod:%@, body:%@,  data:%@",mutableReqeust.URL,mutableReqeust.HTTPMethod,body,datastr);

    
   
    
  
    
    [self.client URLProtocol:self didLoadData:data];
    
    
    
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}




@end

