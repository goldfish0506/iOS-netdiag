//
//  QNNQue.m
//  NetDiag
//
//  Created by BaiLong on 2016/12/7.
//  Copyright © 2016年 Qiniu Cloud Storage. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNNQue.h"

@interface QNNQue ()

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation QNNQue

+ (instancetype)sharedInstance {
    static QNNQue *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
- (instancetype)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return self;
}

+ (void)async_run_serial:(dispatch_block_t)block {
    [[QNNQue sharedInstance].queue addOperationWithBlock:^{
        block();
    }];
}

+ (void)async_run_main:(dispatch_block_t)block {
    [[QNNQue sharedInstance].queue addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), block);
    }];
    
}

+ (void)cancelAllOperations
{
    [[QNNQue sharedInstance].queue cancelAllOperations];
}

@end
