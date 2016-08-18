//
//  BulletManager.h
//  BulletScreen
//
//  Created by Paul on 16/8/17.
//  Copyright © 2016年 yudo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;

@interface BulletManager : NSObject

//弹幕的数据来源
@property (nonatomic,strong) NSMutableArray *datasource;

@property (nonatomic,copy) void(^generateViewBlock)(BulletView *view);

//弹幕开始执行
- (void)start;

//弹幕停止执行
- (void)stop;

@end
