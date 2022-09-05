//
//  HJSwitchView.h
//  MMDataMall
//
//  Created by OO on 2018/8/22.
//  Copyright © 2018年 libiao. All rights reserved.
//

#import "BaseViewController.h"

@class HJSwitchView;
@protocol HJSwitchViewDelegate <NSObject>
- (void)switchView:(HJSwitchView *)switchView hasChangedIndex:(NSInteger)index;
@end

@interface HJSwitchView : BaseView
/** 文字默认颜色 */
@property (nonatomic, strong) UIColor * titleDefaultcolor;
/** 文字选中颜色 */
@property (nonatomic, strong) UIColor * titleSelectedColor;
/** 滑条颜色 */
@property (nonatomic, strong) UIColor * drawColor;
/** 选中序号 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 滑条长度百分比 */
@property (nonatomic, assign) CGFloat lineTakePercent;

/** 滑条长度百分比 */
@property (nonatomic, assign) CGFloat fontSize;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, weak) id <HJSwitchViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (void)changeSelectedIndex:(NSInteger)index;
- (void)setItems:(NSArray *)items;
@end
