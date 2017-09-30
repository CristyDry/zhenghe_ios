//
//  UIColor+Toos.h
//  demo10-9
//
//  Created by xx on 15/10/12.
//  Copyright (c) 2015年 xx. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIImage+Tools.h"

@interface UIColor (Toos)

/**
 *  将图片转为颜色
 *
 *  @param imageName 图片名
 *
 *  @return
 */
+(UIColor *)colorWithImageName:(NSString *)imageName;


+ (UIColor *)colorWithRGB:(CGFloat)R G:(CGFloat) G B:(CGFloat) B;

/**
 *
 *
 *  @param color <#color description#>
 *  @param alpha <#alpha description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 *  颜色转为图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+ (UIImage*) imageWithColor: (UIColor*) color;

@end
