//
//  UIView+Extension.h
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

typedef NS_ENUM(NSInteger,PositionType)
{
    kTop_Type = 200,
    kBottom_Type,
};

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x_wcr;
@property (nonatomic, assign) CGFloat y_wcr;

@property (nonatomic, assign) CGFloat maxX_wcr;
@property (nonatomic, assign) CGFloat maxY_wcr;

@property (nonatomic, assign) CGFloat centerX_wcr;
@property (nonatomic, assign) CGFloat centerY_wcr;
@property (nonatomic, assign) CGFloat width_wcr;
@property (nonatomic, assign) CGFloat height_wcr;
@property (nonatomic, assign) CGSize size_wcr;


// 创建一个view，作为背景，在此view上添加控件
-(UIView*)popCustomView;

/**
 *  给view下面添加一条分割线
 */
- (UIView *)addLineViewAtPosition:(PositionType)position;

/**
 *  圆形风格  要先设置farme
 */
- (void)roundType;

@end
