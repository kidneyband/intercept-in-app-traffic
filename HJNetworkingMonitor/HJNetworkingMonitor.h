//
//  HJNetworkingMonitor.h
//  HJFoundation
//
//  Created by lchen on 16/05/2017.
//  Copyright © 2017 Hujiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJNetworkingMonitor : NSObject

/**
 开启网路监控

 @param enable 是否开启网络监控
 */
+ (void)setEnable:(BOOL)enable;

@end
