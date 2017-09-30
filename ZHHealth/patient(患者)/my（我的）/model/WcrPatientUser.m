//
//  WcrPatientUser.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrPatientUser.h"

@implementation WcrPatientUser

+(WcrPatientUser *)getWcrPatientUser {
    
    WcrPatientUser *user = [[self alloc]init];
    
    user.icon = @"患者默认头像";
    user.name = @"ZHMedical";
    user.gender = @"男";
    user.birthday = @"1992年4月8日";
    user.home = @"广东-广州-天河区";
    
    return user;
}

@end
