//
//  SYPageControlView.m
//  ZhanLuYueDu
//
//  Created by zlwh on 2019/7/12.
//  Copyright © 2019 ZhanLuYueDu. All rights reserved.
//

#import "SYPageControlView.h"
#import "UIViewExt.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface SYPageControlView ()
{
    UIButton *_seletedBtn;
    float menuBtnWidth;
    NSMutableArray *titleBtnArr;
}
@property (nonatomic,strong) UIScrollView          *pageScroll;  //内容
@property (nonatomic,copy)   NSArray               *viewControllers;
@property (nonatomic,strong) UIView                *indicatorView;
@property (nonatomic,strong) UIScrollView          *btnView;   //可滑动的
@property (nonatomic,copy)   NSArray               *titleArray;


@end

@implementation SYPageControlView

-(instancetype)initWithFrame:(CGRect)frame controllertitles:(NSArray *)titles childViewControllers:(NSArray *)childVCs delegate:(id <SYPageControlIndexDelegate>)delegate{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = titles;
        self.viewControllers = childVCs;
        self.delegate = delegate;
        
        self.maxMenuCount = childVCs.count;
        menuBtnWidth = self.width/childVCs.count;
        
        //设置默认属性
        [self initWithProperty];
        //创建子视图
        [self createSubViews];
        
    }
    return self;
}

//初始化默认属性值
- (void)initWithProperty
{
    self.selectIndex = 0;
    self.titleNormalColor = [UIColor blackColor];
    self.titleSelectColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:15];
    self.indicatorWidth = 50;
    self.indicatorHeight = 1;
    self.indicatorColor = self.titleSelectColor;
    self.titleSelectFont = self.titleFont;
    self.btnViewHeight = 42;
    
}

-(void)createSubViews{
    //1.头部titles
    _btnView = [[UIScrollView alloc]init];
    _btnView.frame = CGRectMake(0,0,SCREEN_WIDTH,self.btnViewHeight);
    _btnView.showsHorizontalScrollIndicator = NO;
    _btnView.backgroundColor = [UIColor whiteColor];
    _btnView.contentSize = CGSizeMake(menuBtnWidth*self.titleArray.count, self.btnViewHeight);
    [self addSubview:_btnView];
    
    //2.标题按钮
    titleBtnArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.titleArray.count; i++)  {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+10;
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        btn.titleLabel.font = self.titleFont;
        
        btn.frame = CGRectMake(menuBtnWidth*i, 0, menuBtnWidth, self.btnViewHeight);
        [_btnView addSubview:btn];
        
        if (i==self.selectIndex) {
            _seletedBtn = btn;
            _seletedBtn.titleLabel.font = self.titleSelectFont;
            [_seletedBtn setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtnArr addObject:btn];
    }
    
    //3.下划线
    self.indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.indicatorWidth, self.indicatorHeight)];
    self.indicatorView.backgroundColor = self.indicatorColor;
    self.indicatorView.center = CGPointMake(menuBtnWidth/2, self.btnViewHeight-self.indicatorHeight/2-1);//底部留1
    [_btnView addSubview:self.indicatorView];
    
    
    //4.内容VC
    self.pageScroll = [[UIScrollView alloc] init];
    self.pageScroll.delegate = self;
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.bounces = NO;
    self.pageScroll.frame = CGRectMake(0,self.btnViewHeight, self.width, self.height - self.btnViewHeight);
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.contentSize = CGSizeMake(self.width*self.viewControllers.count, self.pageScroll.height);
    self.pageScroll.contentOffset = CGPointMake(self.width*self.selectIndex, 0); //根据默认index设置偏移量
    [self addSubview:self.pageScroll];
    
    for (int i = 0; i<self.viewControllers.count; i++) {
        UIViewController *vc = self.viewControllers[i];
        vc.view.frame = CGRectMake(i*self.width, 0, self.width, self.pageScroll.height);
        [self.pageScroll addSubview:vc.view];
    }
    
}


#pragma mark - 事件
-(void)btnClick:(UIButton *)sender{
    
    if (_seletedBtn==sender) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageIndexDidChange:)]) {
        [self.delegate pageIndexDidChange:sender.tag-10];
    }
    
    for (UIButton *btn in titleBtnArr) {
        btn.titleLabel.font = self.titleFont;
        [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.center = CGPointMake(sender.center.x, self.btnViewHeight-self.indicatorHeight/2-1);//底部留1
        
        //想点击没有动画就把这个移到下面
        self.pageScroll.contentOffset = CGPointMake((sender.tag-10)*self.width, 0);
        [self.pageScroll setContentOffset:CGPointMake((sender.tag-10)*self.width, 0) animated:NO];
    }];
    
    sender.titleLabel.font = self.titleSelectFont;
    [sender setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
    _seletedBtn = sender;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float index = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageIndexDidChange:)]) {
        [self.delegate pageIndexDidChange:index];
    }
    
    UIButton *btn = (UIButton *)[self.btnView viewWithTag:index+10];
    if (_seletedBtn != btn) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.center = CGPointMake(btn.center.x, self.btnViewHeight-self.indicatorHeight/2-1);//底部留1
        }];
        
        _seletedBtn.titleLabel.font = self.titleFont;
        [_seletedBtn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        
        _seletedBtn = btn;
        
        _seletedBtn.titleLabel.font = self.titleSelectFont;
        [_seletedBtn setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
    }
    
}

#pragma mark - set方法
-(void)setBtnViewHeight:(NSInteger)btnViewHeight{
    _btnViewHeight = btnViewHeight;
    
    _btnView.contentSize = CGSizeMake(menuBtnWidth*self.titleArray.count, btnViewHeight);
    self.indicatorView.center = CGPointMake(_seletedBtn.center.x, self.btnViewHeight-self.indicatorHeight/2-1);//底部留1
}

-(void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor = titleNormalColor;
    
    for (UIButton *btn in titleBtnArr) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
    
    [_seletedBtn setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
}

-(void)setTitleSelectColor:(UIColor *)titleSelectColor{
    _titleSelectColor = titleSelectColor;
    
    [_seletedBtn setTitleColor:titleSelectColor forState:UIControlStateNormal];
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    
    for (UIButton *btn in titleBtnArr) {
        btn.titleLabel.font = titleFont;
    }
 
    _seletedBtn.titleLabel.font = self.titleSelectFont;
}

-(void)setTitleSelectFont:(UIFont *)titleSelectFont{
    _titleSelectFont = titleSelectFont;
    
    _seletedBtn.titleLabel.font = titleSelectFont;
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    
    self.pageScroll.contentOffset = CGPointMake(self.width*selectIndex, 0);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageIndexDidChange:)]) {
        [self.delegate pageIndexDidChange:selectIndex];
    }
    UIButton *btn = (UIButton *)[self.btnView viewWithTag:selectIndex+10];
    if (_seletedBtn != btn) {
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.center = CGPointMake(btn.center.x, self.btnViewHeight-self.indicatorHeight/2-1);//底部留1
        }];
        
        _seletedBtn.titleLabel.font = self.titleFont;
        [_seletedBtn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        
        _seletedBtn = btn;
        
        _seletedBtn.titleLabel.font = self.titleSelectFont;
        [_seletedBtn setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
    }
    
}

-(void)setIndicatorColor:(UIColor *)indicatorColor{
    _indicatorColor = indicatorColor;
    
    self.indicatorView.backgroundColor = indicatorColor;
}

-(void)setIndicatorWidth:(NSInteger)indicatorWidth{
    _indicatorWidth = indicatorWidth;
    
    self.indicatorView.frame = CGRectMake(0, 0, indicatorWidth, self.indicatorHeight);
    self.indicatorView.center = CGPointMake(_seletedBtn.center.x, self.btnViewHeight-self.indicatorHeight/2-1);//底部留1
}

-(void)setIndicatorHeight:(NSInteger)indicatorHeight{
    _indicatorHeight = indicatorHeight;
    
    self.indicatorView.frame = CGRectMake(0, 0, self.indicatorWidth, indicatorHeight);
    self.indicatorView.center = CGPointMake(_seletedBtn.center.x, self.btnViewHeight-self.indicatorHeight/2-1);//底部留1
}

-(void)setMaxMenuCount:(NSInteger)maxMenuCount{
    _maxMenuCount = maxMenuCount;
    
    if (self.titleArray.count>maxMenuCount) {
        menuBtnWidth = self.width/maxMenuCount;
        _btnView.contentSize = CGSizeMake(menuBtnWidth*self.titleArray.count, self.btnViewHeight);
        for (int i=0; i<titleBtnArr.count; i++) {
            UIButton *btn = titleBtnArr[i];
            btn.frame = CGRectMake(menuBtnWidth*i, 0, menuBtnWidth, self.btnViewHeight);
        }
    }
}

@end
