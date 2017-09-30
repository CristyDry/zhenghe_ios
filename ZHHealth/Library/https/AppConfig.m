//
//  AppConfig.m
//  CollegeBeeRemember
//
//  Created by zhenfu zhou on 15/3/25.
//  Copyright (c) 2015年 ZhouZhenFu. All rights reserved.
//

#import "AppConfig.h"
#define kUserIdKey @"userIdKey"

@implementation AppConfig

+(void)saveLoginType:(UserState)type {
    [CoreArchive setInt:type key:@"userState"];
}

+(void)removeLoginType:(UserState)type{
    [CoreArchive removeIntForKey:@"userState"];
}

+ (void)saveUserId:(NSString *)userId
{
    [CoreArchive setStr:userId key:kUserIdKey];
}

+ (NSString *)getUserId
{
    return [CoreArchive strForKey:kUserIdKey];
}

+(NSDictionary *)readFileJsonFileName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    
    NSString * xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData * xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    //开始解析这个数据
    /*
     NSJSONReadingMutableContainers 返回一个可变的容器,一般是个一个数组或字典
     */
    NSError * error = nil;
    //
    id retData = [NSJSONSerialization JSONObjectWithData:xmlData options:NSJSONReadingMutableContainers error:&error];
    //读取可变的容器
    
    if ([retData isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *responseDict = [retData objectForKey:@"response"];
        
        return responseDict;
    }
    else
    {
        return nil;
    }

}
+(BOOL)isNullclass:(id)anObject
{
    return [anObject isKindOfClass:[NSNull class]];
}

+(NSString *)changNULLString:(id)string
{
    NSString *str = nil;
    
    if ([string isKindOfClass:[NSNull class]] || !string) {
        
        str = @"未知";
    }
    else
    {
        str = [NSString stringWithFormat:@"%@",string];
    }
    return str;
}

+(NSString *)changAgoTimeDate:(NSString *)release_time
{
    
    if ([release_time isKindOfClass:[NSNull class]] || !release_time) {
        
        return @"未知";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:release_time];
    
    
    NSTimeInterval time = [date timeIntervalSinceNow];
    
    int intTime = -(int)time;
    
    int day = intTime / (3600 *24);
    int remain = intTime % (3600*24);//剩余多少秒
    int hour = remain / 3600;//小时
    remain = intTime % 3600;//剩余多少秒
    int miniute = remain / 60;//剩余分钟
    //int second = remain % 60;//剩余秒
    
    NSString *strTime = nil;
    
    if (day > 0) {
        
        strTime = [NSString stringWithFormat:@"%d天%d小时前",day,hour];
        
    }
    else
    {
        hour = intTime / 3600;
        remain = intTime % 3600;
        miniute = remain / 60;
        
        if (hour > 0) {
            
            strTime = [NSString stringWithFormat:@"%d小时 %d分钟前",hour,miniute];
        }
        else
        {
            miniute = intTime / 60;
            if (miniute > 0) {
                
                strTime = [NSString stringWithFormat:@"%d分钟前",miniute];
            }
            else
            {
                strTime = [NSString stringWithFormat:@"%d秒前",intTime];
            }
        }
        
    }
    
    return strTime;

}



//返回多久时间之后
+(NSString *)changeFutureTimeDate:(NSString *)end_time
{
    if ([end_time isKindOfClass:[NSNull class]] || !end_time) {
        
        return @"未知";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:end_time];
    
    
    NSTimeInterval time = [date timeIntervalSinceNow];
    
    int intTime = (int)time;
    
    int day = intTime / (3600 *24);
    int remain = intTime % (3600*24);//剩余多少秒
    int hour = remain / 3600;//小时
    remain = intTime % 3600;//剩余多少秒
    int miniute = remain / 60;//剩余分钟
    //int second = remain % 60;//剩余秒
    
    NSString *strTime = nil;
    
    if (day > 0) {
        
        strTime = [NSString stringWithFormat:@"%d天%d小时前",day,hour];
        
    }
    else
    {
        hour = intTime / 3600;
        remain = intTime % 3600;
        miniute = remain / 60;
        
        if (hour > 0) {
            
            strTime = [NSString stringWithFormat:@"%d小时 %d分钟后",hour,miniute];
        }
        else
        {
            miniute = intTime / 60;
            if (miniute > 0) {
                
                strTime = [NSString stringWithFormat:@"%d分钟后",miniute];
            }
            else
            {
                strTime = [NSString stringWithFormat:@"%d秒后",intTime];
            }
        }
        
    }
    
    return strTime;

}


#pragma mark  - 保存小米regId (token)
+ (void)saveMiPushTokenWithString:(NSString*)MiPushString;
{
    if ([MiPushString length] == 0) {
        return;
    }
    [CoreArchive setStr:MiPushString key:@"miPushToken"];
}

+ (NSString *)getUUID
{
    NSString *retrieveuuid = [SSKeychain passwordForService:@"U1.new.com"account:@"user"];
    if (nil == retrieveuuid) {
        
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * resultUUID = (__bridge NSString *)CFStringCreateCopy( NULL, uuidString);
        
        [SSKeychain setPassword: [NSString stringWithFormat:@"%@", resultUUID]
                     forService:@"U1.new.com"account:@"user"];
        
        return resultUUID;
    }
    return retrieveuuid;
}

#pragma mark  - 获取小米regId (token)
+ (NSString *)getMiPushToken
{
    NSString *miPhushToken = [CoreArchive strForKey:@"miPushToken"];
    if (nil == miPhushToken) {
        return [AppConfig getUUID];
    }
    return miPhushToken;
}

@end
