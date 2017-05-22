//
//  HJNetworkingMonitor.m
//  HJFoundation
//
//  Created by lchen on 18/05/2017.
//  Copyright © 2017 lchen. All rights reserved.
//

#import "HJNetworkingMonitor.h"
#import "HJURLProtocol.h"


@implementation HJNetworkingMonitor

+ (void)setEnable:(BOOL)enable {
    [HJURLProtocol setEnabled:enable];
}

@end
