//
//  HJNetworkingRecorder.h
//  HJFoundation
//
//  Created by lchen on 16/05/2017.
//  Copyright © 2017 lchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJRequestRecordModel.h"

@interface HJNetworkingRecorder : NSObject

+ (instancetype)sharedRecorder;

- (void)addRequestModel:(HJRequestRecordModel *)requestModel;

@end
