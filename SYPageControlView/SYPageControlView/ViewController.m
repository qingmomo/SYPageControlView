//
//  ViewController.m
//  SYPageControlView
//
//  Created by 黎仕仪 on 2019/7/13.
//  Copyright © 2019 shiyi.Li. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "SYPageControlView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<SYPageControlIndexDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    
}

-(void)createSubViews{
    NSArray *titles = @[@"First",@"Second",@"Third"];
    
    FirstViewController *firstVC = [[FirstViewController alloc]init];
    SecondViewController *secondVC = [[SecondViewController alloc]init];
    ThirdViewController *thirdVC = [[ThirdViewController alloc]init];
    NSArray *controllers = @[firstVC,secondVC,thirdVC];
    
    SYPageControlView *pageControlView = [[SYPageControlView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) controllertitles:titles childViewControllers:controllers delegate:self];
    [self.view addSubview:pageControlView];
    pageControlView.maxMenuCount = 2;
    pageControlView.selectIndex = 1;
    pageControlView.titleSelectFont = [UIFont systemFontOfSize:17];
    pageControlView.titleNormalColor = [UIColor grayColor];
    pageControlView.titleSelectColor = [UIColor brownColor];
    pageControlView.indicatorWidth = SCREEN_WIDTH/2;
    pageControlView.indicatorColor = [UIColor greenColor];
    
}

#pragma mark - SYPageControlIndexDelegate
-(void)pageIndexDidChange:(NSUInteger)index{
    NSLog(@"%ld",index);
}

@end
