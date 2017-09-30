//
//  LoginResponseAccount.h
//  ZHHealth
//
//  Created by pbz on 15/11/26.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LoginResponseAccount : NSObject


@property (nonatomic, copy) NSString *Id; // 用户id

@property (nonatomic, copy) NSString *districtId;

@property (nonatomic, copy) NSString *phone; // 电话

@property (nonatomic, copy) NSString *age;  // 年龄

@property (nonatomic, copy) NSString *accountNumber; //第三方登录

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *cityName; // 用户城市

@property (nonatomic, copy) NSString *avatar;   // 用户头像url
 
@property (nonatomic, copy) NSString *patientName; // 用户名称

@property (nonatomic, copy) NSString *birthday;    // 用户生日

@property (nonatomic, copy) NSString *provincialId; //

@property (nonatomic, copy) NSString *provinceName; // 省份

@property (nonatomic, copy) NSString *districtName; // 市区

@property (nonatomic, copy) NSString *cityId;       // 城市id

@property (nonatomic, copy) NSString *gender;       // 性别

@property (nonatomic, copy) NSString *status;


//@property (nonatomic,copy)  NSString *channel;
//@property (nonatomic,copy)  NSString *createDate;
//@property (nonatomic,copy)  NSString *creator;
//// 用户id
//@property (nonatomic,copy)  NSString *Id;
//@property (nonatomic,copy)  NSString *isNewRecord;
//@property (nonatomic,copy)  NSString *password;
//@property (nonatomic,copy)  NSString *phone;
//@property (nonatomic,copy)  NSString *status;
//@property (nonatomic,copy)  NSString *updateDate;


// 归档
+ (void)encode:(LoginResponseAccount *) account;
// 解档
+ (instancetype)decode;
// 删除登录文件
+ (void)remove;
// 判断是否已登录
+ (BOOL)isLogin;
@end
