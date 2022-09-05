//
//  HJSwitchView.m
//  MMDataMall
//
//  Created by OO on 2018/8/22.
//  Copyright © 2018年 libiao. All rights reserved.
//

#import "HJSwitchView.h"

@interface HJSwitchView ()

@property (nonatomic, copy) NSArray * items;
@property (nonatomic, strong) UILabel * lineDraw;
@end

@implementation HJSwitchView

- (UILabel *)lineDraw {
    if (!_lineDraw) {
        _lineDraw = [[UILabel alloc]init];
        [_lineDraw setBackgroundColor:self.drawColor];
    }
    return _lineDraw;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    if (self = [super initWithFrame:frame]) {
        self.items = [NSArray arrayWithArray:items];
        self.selectedIndex = 0;
        [self initData];
        [self setupView];
    }
    return self;
}

- (void)initData {
    self.titleDefaultcolor = UIColorFromRGB(0x48469E);
    self.titleSelectedColor = normalBlueColor;
    self.drawColor = normalBlueColor;
    
    self.lineTakePercent = 1;
}

- (void)setItems:(NSArray *)items {
    _items = nil;
    _items = [NSArray arrayWithArray:items];
    [self initData];
    [self setupView];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

- (void)setupView {
    self.backgroundColor = UIColorFromRGB(0xffffff);;
    
//    UILabel * line = [[UILabel alloc]init];
//    line.backgroundColor = UIColorFromRGB(0xffb023);;
//    [self addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.leading.trailing.equalTo(@0);
//        make.height.equalTo(@1);
//    }];
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton * itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.titleLabel.numberOfLines = 0;
        itemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [itemBtn setExclusiveTouch:NO];
        [itemBtn setTag:i];
        [itemBtn setFrame:CGRectMake(i*(SCREEN_WIDTH/self.items.count), 0, SCREEN_WIDTH/self.items.count, 40)];
        [itemBtn setTitle:self.items[i] forState:UIControlStateNormal];
        if (!_fontSize||_fontSize<1) {
            _fontSize = 16;
        }
        [itemBtn.titleLabel setFont:systemFont(_fontSize)];
        [itemBtn setTitleColor:self.titleDefaultcolor forState:UIControlStateNormal];
        [itemBtn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        
        [itemBtn setBackgroundImage:[self imageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        
        [itemBtn addTarget:self action:@selector(itemSwitchChangedAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.selectedIndex) {
            itemBtn.selected = YES;
            [itemBtn.titleLabel setFont:BoldSystemFont(_fontSize)];
        }else{
            [itemBtn.titleLabel setFont:systemFont(_fontSize)];
        }
        [self addSubview:itemBtn];
    }
    
    [self addSubview:self.lineDraw];
    [self.lineDraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.bottom.equalTo(@0);
        make.width.equalTo(@((SCREEN_WIDTH/self.items.count)*self.lineTakePercent));
        make.leading.equalTo(@((SCREEN_WIDTH/self.items.count)*(self.selectedIndex+(1-self.lineTakePercent))*0.5));
    }];
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    
    
}

- (void)itemSwitchChangedAction:(UIButton *)sender {
    if (sender.tag != self.selectedIndex) {
        for (UIView * subView in self.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)subView;
                if (btn != sender) {
                    btn.selected = NO;
                    [btn.titleLabel setFont:systemFont(_fontSize)];
                }else{
                    btn.selected = YES;
                    [btn.titleLabel setFont:BoldSystemFont(_fontSize)];
                }
            }
        }
        self.selectedIndex = sender.tag;
        
        [UIView animateWithDuration:.2f animations:^{
//            self.lineDraw.v_left = (WIDTH/self.items.count)*(self.selectedIndex+(1-self.lineTakePercent)*0.5);
            [self.lineDraw setNeedsDisplay];
            [self.lineDraw mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@((SCREEN_WIDTH/self.items.count)*(self.selectedIndex+(1-self.lineTakePercent)*0.5)));
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:.2f animations:^{
                    [self layoutIfNeeded];
                }];
            });
        } completion:^(BOOL finished) {
            
        }];
        
        if ([self.delegate respondsToSelector:@selector(switchView:hasChangedIndex:)]) {
            [self.delegate switchView:self hasChangedIndex:sender.tag];
        }
    }
}

- (void)changeSelectedIndex:(NSInteger)index {
    _selectedIndex = index;
    
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)subView;
            if (btn.tag == index) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
    }
    //    [self.lineDraw mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(@((SCREEN_WIDTH/self.items.count)*(self.selectedIndex+(1-self.lineTakePercent)*0.5)));
    //    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.2f animations:^{
            [self layoutIfNeeded];
        }];
    });
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
