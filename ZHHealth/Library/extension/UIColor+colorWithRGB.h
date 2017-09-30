//
//  UIColor+colorWithRGB.h
//  EHealth_HM
//
//  Created by skusdk on 13-10-12.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(colorWithImage)

+(UIColor *)colorWithImageName:(NSString *)imageName;

//从十六进制字符串获取颜色，alpha默认值为1
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

@interface UIColor (colorWithRGB)
+ (UIColor *)colorWithRGB:(CGFloat)R G:(CGFloat) G B:(CGFloat) B;

@end
