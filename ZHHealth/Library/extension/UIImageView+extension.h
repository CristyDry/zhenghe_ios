//
//  UIImageView+extension.h
//  Car
//
//  Created by U1KJ on 15/8/10.
//  Copyright (c) 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (extension)

/**
 *  登录注册时：手机、密码等图片
 *  isAspectFill:YES，UIViewContentModeScaleAspectFill按比例填充
 */
-(void)imageViewWithImageName:(NSString*)imageName andModeScaleAspectFill:(BOOL)isAspectFill;

-(void)imageViewWithImageName:(NSString *)imageName andModeScaleAspectFill:(BOOL)isAspectFill andCorner:(CGFloat)corner;




@end
