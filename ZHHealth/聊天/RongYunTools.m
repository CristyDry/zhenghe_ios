

//
//  RongYunTools.m
//  Express_IOS
//
//  Created by ZhouZhenFu on 15/11/23.
//  Copyright © 2015年 LuCanAn. All rights reserved.
//

//#define kDeviceToken @"RongCloud_SDK_DeviceToken"

#import "RongYunTools.h"


@implementation RongYunTools

+ (RongYunTools *)shareInstance
{
    static RongYunTools* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        // disableMessageNotificaiton
        [RCIM sharedRCIM].disableMessageNotificaiton = NO;
    });
    return instance;
}
+ (NSString *)getRongYunToken{

   return [CoreArchive strForKey:@"rongyuntoken"];
}
+ (void)saveRongYunToken:(NSString *)token{
    
    [CoreArchive setStr:token key:@"rongyuntoken"];
}

- (void)starRongYunSdk
{
    // 测试：c9kqb3rdku4cj
    // 正式：cpj2xarljd5en
    [[RCIM sharedRCIM] initWithAppKey:@"c9kqb3rdku4cj"];
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;

    if ([LoginResponseAccount isLogin] && [RongYunTools getRongYunToken]) {
        [RongYunTools connectWithToken:[RongYunTools getRongYunToken]];
    }
    if ([HLTLoginResponseAccount isLogin]&& [RongYunTools getRongYunToken]) {
        [RongYunTools connectWithToken:[RongYunTools getRongYunToken]];
    }
}

//+ (void)setDeviceToken:(NSData *)deviceToken
//{
//    NSString *token =
//    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
//                                                           withString:@""]
//      stringByReplacingOccurrencesOfString:@">"
//      withString:@""]
//     stringByReplacingOccurrencesOfString:@" "
//     withString:@""];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kDeviceToken];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
//}

+ (void)connectWithToken:(NSString *)token
{
    CLog(@" 融云token = %@",token);
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        CLog(@"融云连接--------------成功、成功、成功");
    } error:^(RCConnectErrorCode status) {
        CLog(@"融云连接--------------失败、失败、失败");
    } tokenIncorrect:^{
        CLog(@"融云连接--------------Incorrect");
    }];
}

//+ (void)refreshCurUserInfo:(MSSUser *)userInfo
//{
//    RCUserInfo *myUserInfo = [[RCUserInfo alloc]initWithUserId:userInfo.userId name:userInfo.userName portrait:userInfo.avatar];
//
//    [[RCIM sharedRCIM] refreshUserInfoCache:myUserInfo withUserId:userInfo.userId];
//}
+ (void)logout
{
     [RongYunTools saveRongYunToken:nil];
     [RCIMClient sharedRCIMClient].currentUserInfo = nil;
     [[RCIM sharedRCIM] logout];
}

+ (void)setUnreadMsgCountOnIconBadgeNumber
{
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
}


+(void)setDisableMessageAlertSoundWithStatus:(BOOL)isActive {
    [[RCIM sharedRCIM] setDisableMessageAlertSound:isActive];
}

@end
