//
//  ViewController.m
//  BulletScreen
//
//  Created by Paul on 16/8/17.
//  Copyright © 2016年 yudo. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"

@interface ViewController ()

@property (nonatomic,strong)BulletManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [[BulletManager alloc]init];

    __weak typeof(self) weakself = self;
    self.manager.generateViewBlock = ^(BulletView *view){
        [weakself addBulletView:view];
    };
}

- (void)addBulletView:(BulletView *)view
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 + view.tarjectory * 50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}


- (IBAction)startAnimation:(id)sender {
    [self.manager start];
}


- (IBAction)stopAnimation:(id)sender {
    [self.manager stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
