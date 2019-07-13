//
//  SYPageControlView.h
//  ZhanLuYueDu
//
//  Created by zlwh on 2019/7/12.
//  Copyright © 2019 ZhanLuYueDu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYPageControlIndexDelegate <NSObject>

@optional

-(void)pageIndexDidChange:(NSUInteger)index;

@end

@interface SYPageControlView : UIView<UIScrollViewDelegate>

//设置菜单栏高度
@property (nonatomic,assign) NSInteger             btnViewHeight;  

//设置按钮下划线宽度
@property (nonatomic,assign) NSInteger             indicatorWidth;     //默认50，我们最好设置一下
//设置按钮下划线高度(默认1)
@property (nonatomic,assign) NSInteger             indicatorHeight;
//设置最大菜单展示个数，菜单多于最大则可滑动 (默认是childVCs的个数)
@property (nonatomic,assign) NSInteger             maxMenuCount;

@property (nonatomic,weak) id <SYPageControlIndexDelegate> delegate;

/**
 当前选中标题索引，默认0
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 标题字体大小，默认15
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 标题选中字体大小，默认15
 */
@property (nonatomic, strong) UIFont *titleSelectFont;

/**
 标题正常颜色，默认black
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 标题选中颜色，默认red
 */
@property (nonatomic, strong) UIColor *titleSelectColor;

/**
 指示器颜色，默认与titleSelectColor一样,在FSIndicatorTypeNone下无效
 */
@property (nonatomic, strong) UIColor *indicatorColor;


-(instancetype)initWithFrame:(CGRect)frame controllertitles:(NSArray *)titles childViewControllers:(NSArray *)childVCs delegate:(id <SYPageControlIndexDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
