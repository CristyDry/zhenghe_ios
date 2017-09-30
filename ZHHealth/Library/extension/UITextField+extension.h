//
//  UITextField+extension.h
//  Car
//
//  Created by 吴前途 on 15/7/6.
//  Copyright (c) 2015年 吴前途. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (extension)

/**
 *  登录注册:textField
 *
 *  @param placeholder      提示的文字
 *  @param font             字号
 *  @param isSecure         是否为密码框
 *  @param returnKey        返回键类型
 *  @param keyboardType     键盘类型
 *                          内部已添加左右textField的左右视图
 */
-(void)textFieldWithPlaceholder:(NSString*)placeholder andFont:(CGFloat)font andSecureTextEntry:(BOOL)isSecure andReturnKey:(UIReturnKeyType)returnKey andkeyboardType:(UIKeyboardType)keyboardType;


-(void)textFieldWithPlaceholder:(NSString*)placeholder andFont:(CGFloat)font andSecureTextEntry:(BOOL)isSecure;

-(void)disappearTextField;


@end
