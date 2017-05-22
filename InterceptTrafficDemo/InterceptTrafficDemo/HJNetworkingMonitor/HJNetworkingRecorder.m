//
//  HJNetworkingRecorder.m
//  HJFoundation
//
//  Created by lchen on 16/05/2017.
//  Copyright © 2017 lchen. All rights reserved.
//

#import <FMDB/FMDB.h>

#import "HJNetworkingRecorder.h"

@interface HJNetworkingRecorder ()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation HJNetworkingRecorder
static HJNetworkingRecorder *recoder;

+ (NSString *)filePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [path stringByAppendingPathComponent:@"com.lchen.networking.sqlite"];
//    NSLog(@"sql path %@", sqlPath);
    return sqlPath;
}

+ (instancetype)sharedRecorder {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recoder = [[HJNetworkingRecorder alloc] init];
    });
    return recoder;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recoder = [super allocWithZone:zone];
    });
    return recoder;
}

- (instancetype)init {
    if (self = [super init]) {
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[[self class] filePath]];
        // create table
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
            BOOL createSuccess = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_requests(\
             id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,\
             domain TEXT,\
             start_time DATE,\
             end_time DATE,\
             time_interval DOUBle,\
             status_code INTEGER,\
             network_status VARCHAR(255),\
             traffic_size DOUBLE);"];
            if (!createSuccess) {
                [db rollback];
            }
        }];
    }
    return self;
}

- (void)addRequestModel:(HJRequestRecordModel *)requestModel {
    NSLog(@"%@", requestModel);
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO t_requests(domain, start_time, end_time, time_interval, status_code, network_status, traffic_size) VALUES (?, ?, ?, ?, ?, ?, ?);", requestModel.domain, @(requestModel.startTime), @(requestModel.endTime), @(requestModel.timeInterval), @(requestModel.statusCode), requestModel.networkStatus, @(requestModel.trafficSize)];
    }];
    if ([self isMaxCountRecordsReached]) {
        [self clearAllRequestRecords];
    }
}

- (void)clearAllRequestRecords {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM t_requests"];
    }];
}

- (BOOL)isMaxCountRecordsReached {
    __block int count = 0;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        count = [db intForQuery:@"SELECT COUNT(id) FROM t_requests"];
    }];
    return count >= 100;
}

@end
