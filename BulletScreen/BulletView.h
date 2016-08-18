//
//  BulletView.h
//  BulletScreen
//
//  Created by Paul on 16/8/17.
//  Copyright © 2016年 yudo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Start,
    Enter,
    Stop,
} MoveStatus;

@interface BulletView : UIView

@property (nonatomic,assign)int tarjectory;//弹道
@property (nonatomic,copy) void(^moveStatusBlock)(MoveStatus status);//弹幕回调状态

//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;

//开始动画
- (void)startAnimation;

//结束动画
- (void)stopAnimation;
@end
