//
//  WcrPatientUser.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WcrPatientUser : NSObject

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *icon;       // 头像

@property (nonatomic, strong) NSString *name;       // 姓名

@property (nonatomic, strong) NSString *gender;     // 性别

@property (nonatomic, strong) NSString *birthday;   // 出生日期

@property (nonatomic, strong) NSString *home;       // 所在地区

@property (nonatomic, strong) NSString *address;    // 地址

@property (nonatomic, strong) NSString *password;   // 密码

+(WcrPatientUser*)getWcrPatientUser;

@end
