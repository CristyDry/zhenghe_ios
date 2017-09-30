//
//  UIView+Extension.m
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(UIView*)popCustomView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    
    [self addSubview:bgView];
    return bgView;
}

-(void)setX_wcr:(CGFloat)x_wcr{
    CGRect frame = self.frame;
    frame.origin.x = x_wcr;
    self.frame = frame;
}

- (CGFloat)x_wcr
{
    return self.frame.origin.x;
}

-(void)setMaxX_wcr:(CGFloat)maxX_wcr{
    self.x_wcr = maxX_wcr - self.frame.size.width;
}

- (CGFloat)maxX_wcr
{
    return CGRectGetMaxX(self.frame);
}

-(void)setMaxY_wcr:(CGFloat)maxY_wcr{
    self.y_wcr = maxY_wcr - self.frame.size.height;
}

- (CGFloat)maxY_wcr
{
    return CGRectGetMaxY(self.frame);
}

-(void)setY_wcr:(CGFloat)y_wcr{
    CGRect frame = self.frame;
    frame.origin.y = y_wcr;
    self.frame = frame;
}

- (CGFloat)y_wcr
{
    return self.frame.origin.y;
}

-(void)setCenterX_wcr:(CGFloat)centerX_wcr{
    CGPoint center = self.center;
    center.x = centerX_wcr;
    self.center = center;
}

- (CGFloat)centerX_wcr
{
    return self.center.x;
}

-(void)setCenterY_wcr:(CGFloat)centerY_wcr{
    CGPoint center = self.center;
    center.y = centerY_wcr;
    self.center = center;
}

- (CGFloat)centerY_wcr
{
    return self.center.y;
}

-(void)setWidth_wcr:(CGFloat)width_wcr{
    CGRect frame = self.frame;
    frame.size.width = width_wcr;
    self.frame = frame;
}

- (CGFloat)width_wcr
{
    return self.frame.size.width;
}

-(void)setHeight_wcr:(CGFloat)height_wcr{
    CGRect frame = self.frame;
    frame.size.height = height_wcr;
    self.frame = frame;
}

- (CGFloat)height_wcr
{
    return self.frame.size.height;
}

-(void)setSize_wcr:(CGSize)size_wcr{
    CGRect frame = self.frame;
    frame.size = size_wcr;
    self.frame = frame;
}

- (CGSize)size_wcr
{
    return self.frame.size;
}

- (UIView *)addLineViewAtPosition:(PositionType)position
{
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = KLineColor;
    [self addSubview:lineView];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.width);
        make.centerX.equalTo(self.centerX);
        make.height.equalTo(@(1));
        if (position == kTop_Type) {
            make.top.equalTo(self.top);
        }else
        {
            make.bottom.equalTo(self.bottom);
        }
    }];
    return lineView;
}

- (void)roundType
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.clipsToBounds = YES;
}

@end
