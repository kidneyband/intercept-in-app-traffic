//
//  HJRequestRecordModel.h
//  HJFoundation
//
//  Created by lchen on 16/05/2017.
//  Copyright © 2017 Hujiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJRequestRecordModel : NSObject<NSCopying>

@property (nonatomic, copy)     NSString        *domain;
@property (nonatomic, assign)   NSInteger       statusCode;
@property (nonatomic, copy)     NSString        *networkStatus;
@property (nonatomic, assign)   NSTimeInterval  startTime;
@property (nonatomic, assign)   NSTimeInterval  endTime;
@property (nonatomic, assign)   NSTimeInterval  timeInterval;
@property (nonatomic, assign)   double          trafficSize; // 单位是KB

@end
