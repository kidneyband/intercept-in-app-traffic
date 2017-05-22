//
//  HJURLBeforeProtocol.m
//  HJFoundation
//
//  Created by lchen on 22/05/2017.
//  Copyright © 2017 lchen. All rights reserved.
//

#import "HJURLBeforeProtocol.h"
#import "NSURLProtocol+WebKitSupport.h"
#import "HJURLSessionConfiguration.h"

@interface HJURLBeforeProtocol() <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation HJURLBeforeProtocol

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuartion = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuartion delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

+ (void)setEnabled:(BOOL)enabled {
    
    if (enabled) {
        // register custom url protocol for NSURLConnection
        [NSURLProtocol wk_registerScheme:@"https"];
        [NSURLProtocol wk_registerScheme:@"http"];
        [NSURLProtocol registerClass:[HJURLBeforeProtocol class]];
        // register custom url protocol for NSURLSession
        [[HJURLSessionConfiguration defaultConfiguration] load];
    }else {
        [NSURLProtocol wk_unregisterScheme:@"https"];
        [NSURLProtocol wk_unregisterScheme:@"http"];
        [NSURLProtocol unregisterClass:[HJURLBeforeProtocol class]];
        [[HJURLSessionConfiguration defaultConfiguration] unload];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    if (![request.URL.scheme isEqualToString:@"http"] && ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:@"HJURLBeforeKey" inRequest:request]) {
        // this request has being modified by HJURLProtcol
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    // set property key to request
    [NSURLProtocol setProperty:@YES forKey:@"HJURLBeforeKey" inRequest:mutableRequest];
    return [mutableRequest copy];
}

- (void)startLoading {
    NSLog(@"before protocol request");
    __weak typeof(self) weakSelf = self;
    self.dataTask = [self.session dataTaskWithRequest:[[self class] canonicalRequestForRequest:self.request] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"before protocol completion");
        if (error) {
            [weakSelf.client URLProtocol:weakSelf didFailWithError:error];
        } else {
            [weakSelf.client URLProtocol:weakSelf didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
            [weakSelf.client URLProtocol:weakSelf didLoadData:data];
            [weakSelf.client URLProtocolDidFinishLoading:weakSelf];
        }
    }];
    [self.dataTask resume];
}

- (void)stopLoading {
    [self.dataTask cancel];
}

@end
