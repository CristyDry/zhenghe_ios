//
//  UITextField+extension.m
//  Car
//
//  Created by 吴前途 on 15/7/6.
//  Copyright (c) 2015年 吴前途. All rights reserved.
//

#import "UITextField+extension.h"

@implementation UITextField (extension)

/**
 *  textField属性
 *  placeholder:提示信息
 *  Font:字体大小
 *  ClearButtonMode:清除内容模式
 *  isSecure:是否安全模式（密码）
 */
-(void)textFieldWithPlaceholder:(NSString*)placeholder andFont:(CGFloat)font andSecureTextEntry:(BOOL)isSecure{
    // 提示信息
    self.placeholder = placeholder;
    // 字体大小
    self.font = [UIFont systemFontOfSize:font];
    // 清除内容模式
    self.clearButtonMode = UITextFieldViewModeAlways;
    // 是否安全模式（密码）
    self.secureTextEntry = isSecure;
    
}

-(void)textFieldWithPlaceholder:(NSString *)placeholder andFont:(CGFloat)font andSecureTextEntry:(BOOL)isSecure andReturnKey:(UIReturnKeyType)returnKey andkeyboardType:(UIKeyboardType)keyboardType{
    // 提示信息
    self.placeholder = placeholder;
    // 字体大小
    self.font = [UIFont systemFontOfSize:font];
    // 清除内容模式
    self.clearButtonMode = UITextFieldViewModeAlways;
    // 是否安全模式（密码）
    self.secureTextEntry = isSecure;
    
    // 左右视图
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10.0, self.height_wcr)];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
//    self.rightView = leftView;
//    self.rightViewMode = UITextFieldViewModeAlways;
    
    if (returnKey) {
        self.returnKeyType = returnKey;
    }
    if (keyboardType) {
        self.keyboardType = keyboardType;
    }
}

-(void)disappearTextField {
    [self respondsToSelector:@selector(touchesBegan:withEvent:)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resignFirstResponder];
}

@end
