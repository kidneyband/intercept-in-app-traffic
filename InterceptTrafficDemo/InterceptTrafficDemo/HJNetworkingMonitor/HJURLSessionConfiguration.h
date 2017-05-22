//
//  HJURLSessionConfiguration.h
//  HJFoundation
//
//  Created by lchen on 15/05/2017.
//  Copyright © 2017 lchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJURLSessionConfiguration : NSURLSessionConfiguration

+ (HJURLSessionConfiguration *)defaultConfiguration;

- (void)load;

- (void)unload;

@end
