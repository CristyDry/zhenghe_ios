//
//  UIButton+category.m
//  financial
//
//  Created by 全日制 on 15/6/13.
//  Copyright (c) 2015年 U1KJ. All rights reserved.
//

#import "UIButton+category.h"

@implementation UIButton (category)

/**
 *  使用button画边框
 */
-(void)setBorderOfButton{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0];
    [self.layer setBorderWidth:1.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(colorSpace, (CGFloat[]){192.0/255.0f,192.0/255.0f,192.0/255.0f,1});    // 灰色
    [self.layer setBorderColor:colorRef];
    self.backgroundColor = [UIColor clearColor];        //     背景颜色
    [self setEnabled:NO];    // 不可点击
}

/**
 *  设置按钮的标题、背景图片、字体大小、字体颜色
 *  比如登陆、注册按钮等
 */
-(void)buttonWithTitle:(NSString*)title andTitleColor:(UIColor*)titleColor andBackgroundImageName:(NSString*)imageName andFontSize:(CGFloat)fontSize{
    
    [self setTitle:title forState:0];
    
    [self setTitleColor:titleColor forState:0];
    
    if (imageName) {
       [self setBackgroundImage:[UIImage imageFileNamed:imageName andType:YES] forState:0];
    }else {
        self.backgroundColor = [UIColor clearColor];
    }
    
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
}

#pragma mark - 设置按钮的点击范围
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

-(void)buttonWithTitle:(NSString *)title CornerRadius:(CGFloat)corner BorderWidth:(CGFloat)borderWidth boderColorref:(CGColorRef)color{
    [self setTitle:title forState:UIControlStateNormal];
    [self.layer setMasksToBounds:YES];//允许圆角
    [self.layer setCornerRadius:corner];//圆角幅度
    [self.layer setBorderWidth:borderWidth]; //边框宽度
    [self.layer setBorderColor:color];//边框颜色
}

-(void)addTarget:(id)target action:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
