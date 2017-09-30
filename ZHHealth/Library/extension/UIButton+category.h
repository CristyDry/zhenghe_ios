//
//  UIButton+category.h
//  financial
//
//  Created by 全日制 on 15/6/13.
//  Copyright (c) 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (category)

/**
 *  使用button画边框
 */
-(void)setBorderOfButton;

/**
 *  设置按钮的标题、背景图片、字体大小、字体颜色
 *  比如登陆、注册按钮等
 */
-(void)buttonWithTitle:(NSString*)title andTitleColor:(UIColor*)titleColor andBackgroundImageName:(NSString*)imageName andFontSize:(CGFloat)fontSize;

/**
 *  设置按钮的点击范围
 *
 *  @param top    上边范围
 *  @param right  右边范围
 *  @param bottom 下边范围
 *  @param left   左边范围
 */
- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

/**
 *  设置带边框按钮
 *
 *  @param title       标题
 *  @param corner      圆角
 *  @param borderWidth 边框宽度
 *  @param color       边框的颜色
 */
- (void)buttonWithTitle:(NSString *)title CornerRadius:(CGFloat)corner BorderWidth:(CGFloat)borderWidth boderColorref:(CGColorRef)color;

-(void)addTarget:(id)target action:(SEL)action;

@end
