//
//  HLTLoginResponseAccount.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 16/1/6.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTLoginResponseAccount : NSObject


@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *doctor;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *professional;

@property (nonatomic, copy) NSString *hospital;

@property (nonatomic, copy) NSString *professionalField;

@property (nonatomic, copy) NSString *intro;

@property (nonatomic, copy) NSString *department;


// 归档
+ (void)encode:(HLTLoginResponseAccount *) account;
// 解档
+ (instancetype)decode;
// 删除登录文件
+ (void)remove;
// 判断是否已登录
+ (BOOL)isLogin;

@end
