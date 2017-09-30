//
//  AppConfig.h
//  CollegeBeeRemember
//
//  Created by zhenfu zhou on 15/3/25.
//  Copyright (c) 2015年 ZhouZhenFu. All rights reserved.
//

typedef NS_ENUM(int)
{
    
    kPatient, 
    kDoctor
    
}UserState;

#import <Foundation/Foundation.h>
#import "ModeTextView.h"


@interface AppConfig : NSObject

//保存登录方式
+ (void)saveLoginType:(UserState)type;

//移除登录方式
+(void)removeLoginType:(UserState)type;

//保存用户
+ (void)saveUserId:(NSString *)userId;

//读取用户
+ (NSString *)getUserId;

+(NSDictionary *)readFileJsonFileName:(NSString *)fileName;

+(NSString *)changNULLString:(id)string;


+(BOOL)isNullclass:(id)anObject;

//返回多久时间之前
+(NSString *)changAgoTimeDate:(NSString *)release_time;

//返回多久时间之后
+(NSString *)changeFutureTimeDate:(NSString *)end_time;

typedef void (^UICallback)(id obj);//全局回调..(void(^)(NSString *searchText)) block  typedef void(^onSearch)(NSString *searchText);

/**
 *  获取token
 *
 *  @param MiPushString
 */
+ (NSString *) getMiPushToken;

/**
 *  保存小米推送的regId
 *
 *  @param MiPushString
 */
+ (void)saveMiPushTokenWithString:(NSString*)MiPushString;


@end
