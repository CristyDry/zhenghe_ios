//
//  UILabel+extension.h
//  Car
//
//  Created by 吴前途 on 15/7/6.
//  Copyright (c) 2015年 吴前途. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (extension)

/**
 *  Text：内容
 *  FontSize：字体大小
 *  BackgroundColor：背景颜色
 */
-(void)labelWithText:(NSString*)text andTextColor:(UIColor*)textColor andFontSize:(CGFloat)fontSize andBackgroundColor:(UIColor*)color;

/**
 *  计算文本的宽高（给定宽度）
 *
 *  @param content  内容
 *  @param fontSize 字体大小
 *  @param maxWidth 最大的宽度
 *
 *  @return 返回内容的宽高
 */
+(CGSize)labelContentSizeWithContent:(NSString*)content andFontSize:(CGFloat)fontSize andMaxWidth:(CGFloat)maxWidth;


/**
 *  检测字符串是否包含checkStr
 *
 *  @param OriginalStr 原来的字符串
 *  @param checkString 需要检测的string
 *
 *  @return YES：存在；NO：不存在
 */
-(BOOL)stringIncludeStringWithOriginal:(NSString*)OriginalStr andCheckString:(NSString*)checkString;

/**
 *  检测是否包含checkStr，若存在替换，否则返回原来的string
 *
 *  @param OriginalStr 原来的字符串
 *  @param checkString 需要检测的string
 *  @param replaceStr  替换的字符串
 *
 *  @return 检测到存在则替换，否则返回原来的字符串
 */
-(NSString*)stringIncludeStringWithOriginal:(NSString*)OriginalStr andCheckString:(NSString*)checkString andReplaceString:(NSString*)replaceStr;


@end
