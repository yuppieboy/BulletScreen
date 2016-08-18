//
//  BulletManager.m
//  BulletScreen
//
//  Created by Paul on 16/8/17.
//  Copyright © 2016年 yudo. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager()

//弹幕使用过程中的数组变量
@property (nonatomic,strong) NSMutableArray *bulletComments;
//存储弹幕view的数组变量
@property (nonatomic,strong) NSMutableArray *bulletViews;

@property BOOL bStopAnimation;

@end

@implementation BulletManager

- (instancetype)init
{
    if(self = [super init])
    {
        self.bStopAnimation = YES;
    }
    return self;
}

- (void)start
{
    if (!self.bStopAnimation) {
        return;
    }
    
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.datasource];
    
    [self initBulletComment];
}

- (void)stop
{
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
    }];
    
    [self.bulletViews removeAllObjects];
}


//初始化弹幕，随机分配弹幕轨迹
- (void)initBulletComment
{
    NSMutableArray *trajectorys=[NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i<3; i++) {
        
        if (self.bulletComments.count>0) {
            //通过随机数取出弹幕轨迹
            NSInteger index = arc4random()%(trajectorys.count);
            int trajectory = [trajectorys[index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组中逐一取出弹幕
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
        
    }
}


- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory
{
    if (self.bStopAnimation) {
        return;
    }
    BulletView *view=[[BulletView alloc]initWithComment:comment];
    view.tarjectory=trajectory;
    [self.bulletViews addObject:view];
    
    __weak typeof (view) weakView = view;
    __weak typeof (self) wealself = self;

    view.moveStatusBlock = ^(MoveStatus status){
        if (self.bStopAnimation) {
            return;
        }
        switch (status) {
            case Start:{
                //弹幕开始进入屏幕
                [wealself.bulletViews addObject:weakView];
                break;
            }
            case Enter:{
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在弹幕轨迹中创建一个弹幕
                NSString *comment = [wealself nextCommet];
                if (comment) {
                    [wealself createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case Stop :{
                //弹幕飞出屏幕后从bulletviews中删除，释放资源
                if ([wealself.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [wealself.bulletViews removeObject:weakView];

                }
                
                if (self.bulletViews.count == 0) {
                    self.bStopAnimation = YES;
                    [wealself start];
                }
                
                break;
            }
            default:
                break;
                
        }
        
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSString *)nextCommet
{
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}



- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource=[NSMutableArray arrayWithArray:@[@"弹幕1～～～～",
                                                     @"弹幕2～～～～～～～～",
                                                     @"弹幕3～～～～～～～～～",
                                                     @"弹幕4～～～～～～～～",
                                                     @"弹幕5～～～～～～",
                                                     @"弹幕6～～",
                                                     @"弹幕7～～～～",
                                                     @"弹幕8～～",
                                                     @"弹幕9～～～～～～～～～～～～～～～～～～～",
                                                     @"弹幕10～～～～～～～～",
                                                     @"弹幕11～～～～～～",
                                                     @"弹幕12～～"]];
    }
    return _datasource;
}

- (NSMutableArray *)bulletComments
{
    if (!_bulletComments) {
        _bulletComments=[NSMutableArray array];
    }
    return _bulletComments;
}


- (NSMutableArray *)bulletViews
{
    if (!_bulletViews) {
        _bulletViews=[NSMutableArray array];
    }
    return _bulletViews;
}


@end
