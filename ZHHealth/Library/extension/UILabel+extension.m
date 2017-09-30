//
//  UILabel+extension.m
//  Car
//
//  Created by 吴前途 on 15/7/6.
//  Copyright (c) 2015年 吴前途. All rights reserved.
//

#import "UILabel+extension.h"

@implementation UILabel (extension)

-(void)labelWithText:(NSString *)text andTextColor:(UIColor *)textColor andFontSize:(CGFloat)fontSize andBackgroundColor:(UIColor *)color{
    
    self.text = text;
    
    if (textColor) {
        self.textColor = textColor;
    }
    
    self.font = [UIFont systemFontOfSize:fontSize];
    
    if (color) {
        self.backgroundColor = color;
    }else {
        self.backgroundColor = [UIColor clearColor];
    }
}

+(CGSize)labelContentSizeWithContent:(NSString *)content andFontSize:(CGFloat)fontSize andMaxWidth:(CGFloat)maxWidth{
    
    // 计算文本的高度
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.text = content;
    label.font = [UIFont systemFontOfSize:fontSize];
    CGRect rectOfText = CGRectMake(0, 0, maxWidth, 999);
    rectOfText = [label textRectForBounds:rectOfText limitedToNumberOfLines:0];
    
    return rectOfText.size;
}


-(BOOL)stringIncludeStringWithOriginal:(NSString *)OriginalStr andCheckString:(NSString *)checkString{
    
    if (![OriginalStr isEqualToString:nil] && ![OriginalStr isEqualToString:@""]) {
        if ([OriginalStr rangeOfString:checkString].location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

-(NSString *)stringIncludeStringWithOriginal:(NSString *)OriginalStr andCheckString:(NSString *)checkString andReplaceString:(NSString *)replaceStr{
    
    if (![OriginalStr isEqualToString:nil] && ![OriginalStr isEqualToString:@""]) {
        if ([OriginalStr rangeOfString:checkString].location != NSNotFound) {
//            NSLog(@"change:%@--checkStr:%@--replaceStr:%@",changedStr,checkStr,replaceStr);
            OriginalStr = [OriginalStr stringByReplacingOccurrencesOfString:checkString withString:replaceStr];
//            NSLog(@"1111change:%@--checkStr:%@--replaceStr:%@",changedStr,checkStr,replaceStr);
        }
    }
    
    return OriginalStr;
    
}




@end
