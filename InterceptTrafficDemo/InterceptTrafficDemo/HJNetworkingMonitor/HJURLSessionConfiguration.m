//
//  HJURLSessionConfiguration.m
//  HJFoundation
//
//  Created by lchen on 15/05/2017.
//  Copyright © 2017 lchen. All rights reserved.
//

#import <objc/runtime.h>

#import "HJURLSessionConfiguration.h"
#import "HJURLProtocol.h"

@implementation HJURLSessionConfiguration

+ (HJURLSessionConfiguration *)defaultConfiguration {
    
    static HJURLSessionConfiguration *staticConfiguration;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticConfiguration=[[HJURLSessionConfiguration alloc] init];
    });
    return staticConfiguration;
}

- (void)load {
    Class originalClass = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:originalClass toClass:[self class]];
}

- (void)unload {
    Class replacedClass = NSClassFromString(@"__NSCFURLSessionConfiguration") ?: NSClassFromString(@"NSURLSessionConfiguration");
    [self swizzleSelector:@selector(protocolClasses) fromClass:replacedClass toClass:[self class]];
}

- (void)swizzleSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NEURLSessionConfiguration."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)protocolClasses {
    return @[[HJURLProtocol class]];
}


@end
