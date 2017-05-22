//
//  HJURLProtocol.m
//  HJFoundation
//
//  Created by lchen on 15/05/2017.
//  Copyright © 2017 lchen. All rights reserved.
//

#import "HJURLProtocol.h"
#import "HJURLSessionConfiguration.h"
#import "NSURLProtocol+WebKitSupport.h"
#import "HJNetworkingRecorder.h"

NSString *kHJHttpKey = @"kHJHttpKey";

@interface HJURLProtocol() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) HJRequestRecordModel *requestModel;

@end

@implementation HJURLProtocol

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
        [NSURLProtocol registerClass:[HJURLProtocol class]];
        // register custom url protocol for NSURLSession
        [[HJURLSessionConfiguration defaultConfiguration] load];
    }else {
        [NSURLProtocol wk_unregisterScheme:@"https"];
        [NSURLProtocol wk_unregisterScheme:@"http"];
        [NSURLProtocol unregisterClass:[HJURLProtocol class]];
        [[HJURLSessionConfiguration defaultConfiguration] unload];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    if (![request.URL.scheme isEqualToString:@"http"] && ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:kHJHttpKey inRequest:request]) {
        // this request has being modified by HJURLProtcol
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    // set property key to request
    [NSURLProtocol setProperty:@YES forKey:kHJHttpKey inRequest:mutableRequest];
    return [mutableRequest copy];
}

- (void)startLoading {
    __weak typeof(self) weakSelf = self;
    self.dataTask = [self.session dataTaskWithRequest:[[self class] canonicalRequestForRequest:self.request] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        weakSelf.requestModel.statusCode = ((NSHTTPURLResponse *)response).statusCode;
        weakSelf.requestModel.trafficSize = response.expectedContentLength > 0 ? response.expectedContentLength : 0;
        if (error) {
            [weakSelf.client URLProtocol:weakSelf didFailWithError:error];
        } else {
            [weakSelf.client URLProtocol:weakSelf didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
            [weakSelf.client URLProtocol:weakSelf didLoadData:data];
            [weakSelf.client URLProtocolDidFinishLoading:weakSelf];
        }
    }];
    [self.dataTask resume];
    self.requestModel = [[HJRequestRecordModel alloc] init];
    self.requestModel.domain = self.request.URL.host;
    self.requestModel.startTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)stopLoading {
    [self.dataTask cancel];
    [self.session invalidateAndCancel];
    if (self.requestModel.statusCode != 0) {
        self.requestModel.endTime = [NSDate timeIntervalSinceReferenceDate];
        self.requestModel.timeInterval = self.requestModel.endTime - self.requestModel.startTime;
        [[HJNetworkingRecorder sharedRecorder] addRequestModel:self.requestModel];
    }
}

@end
