//
//  BulletView.m
//  BulletScreen
//
//  Created by Paul on 16/8/17.
//  Copyright © 2016年 yudo. All rights reserved.
//

#import "BulletView.h"

#define Padding 10

@interface BulletView()
@property (nonatomic,strong)UILabel *lbComment;

@end

@implementation BulletView



//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment
{
    if (self = [super init]) {
        self.backgroundColor=[UIColor redColor];
        
        //计算弹幕实际宽度
        NSDictionary *attr =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat witch = [comment sizeWithAttributes:attr].width;
        self.bounds = CGRectMake(0, 0, witch + 2 * Padding, 30);
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding, 0, witch, 30);
    
    }
    return self;
}

//开始动画
- (void)startAnimation
{
    //根据弹幕长度执行动画
    //v=s/t,时间相同情况下，距离越长，速度越快
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    
    //t=s/v
    CGFloat speed = wholeWidth/duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.moveStatusBlock) {
            self.moveStatusBlock(Stop);
        }
    }];
}

//结束动画
- (void)stopAnimation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (UILabel *)lbComment
{
    if (_lbComment == nil) {
        _lbComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}


- (void)enterScreen
{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
