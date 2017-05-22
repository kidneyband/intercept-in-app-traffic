//
//  HJRequestRecordModel.m
//  HJFoundation
//
//  Created by lchen on 16/05/2017.
//  Copyright © 2017 Hujiang. All rights reserved.
//

#import <Reachability/Reachability.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "HJRequestRecordModel.h"

@implementation HJRequestRecordModel

- (instancetype)init {
    if (self = [super init]) {
        self.networkStatus = [[self class] networkStatus];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    HJRequestRecordModel *model = [[HJRequestRecordModel alloc] init];
    model.domain = self.domain;
    model.startTime = self.startTime;
    model.endTime = self.endTime;
    model.statusCode = self.statusCode;
    model.networkStatus = self.networkStatus;
    model.trafficSize = self.trafficSize;
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"request model detail info:\n domain: %@ \n startTime: %f \n endTime: %f \n timeInterval: %f \n statusCode: %ld \n networkStatus: %@ \n trafficSize: %f", self.domain, self.startTime, self.endTime, self.timeInterval, (long)self.statusCode, self.networkStatus, self.trafficSize];
}

+ (NSString *)networkStatus {
    Reachability *reachAble=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status = [reachAble currentReachabilityStatus];
    if(status == NotReachable){//没有网络
        return @"No Network";
    }else if (status == ReachableViaWiFi){
        return @"WIFI";
    }
    
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = networkStatus.currentRadioAccessTechnology;
    
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
        //GPRS网络
        return @"2G GPRS";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
        //2.75G的EDGE网络
        return @"2.5G EDGE";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        //3G WCDMA网络
        return @"3G WCDMA";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        //3.5G网络
        return @"3.5G HSDPA";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        //3.5G网络
        return @"3G HSUPA";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        //CDMA2G网络
        return @"2G CDMA1x";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        //CDMA的EVDORev0(应该算3G吧?)
        return @"3G CDMAEVDORev0";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        //CDMA的EVDORevA(应该也算3G吧?)
        return @"3G CDMAEVDORevA";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        //CDMA的EVDORev0(应该还是算3G吧?)
        return @"3G CDMAEVDORevB";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        //HRPD网络
        return @"3G HRPD";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        //LTE4G网络
        return @"4G LTE4G";
    }
    if (!currentStatus) {
        return @"Unknow";
    }
    return currentStatus;
}

@end
