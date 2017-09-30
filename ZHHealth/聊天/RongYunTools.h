//
//  RongYunTools.h
//  Express_IOS
//
//  Created by ZhouZhenFu on 15/11/23.
//  Copyright © 2015年 LuCanAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>
#import <RongIMKit/RongIMKit.h>
#import "RCDRCIMDataSource.h"
#import "RongYunHttp.h"

@interface RongYunTools : NSObject


+(RongYunTools *) shareInstance;

+ (NSString *)getRongYunToken;
+ (void)saveRongYunToken:(NSString *)token;

//** 初始化融云的key 设置融云用户资料的提供者 并成为融云状态的监听者 */
- (void)starRongYunSdk;

////*  设置推送token */
//+ (void)setDeviceToken:(NSData *)deviceToken;
//

/**
 *  一般在登录成功后，拿到融云token 调用
 *
 *  @param token 融云token
 */
+ (void)connectWithToken:(NSString *)token;

//** 刷新融云的用户资料 更改了用户个人资料时调用 */
//+ (void)refreshCurUserInfo:(MSSUser *)userInfo;

/**
 *  Log out。不会接收到push消息。
 */
+ (void)logout;

/**
 *  设置未读消息 到桌面图片红点 在进入后台时调用
 */
+ (void)setUnreadMsgCountOnIconBadgeNumber;


+(void)setDisableMessageAlertSoundWithStatus:(BOOL)isActive;

// [[RCIM sharedRCIM] setDisableMessageAlertSound:!button.selected];

@end
