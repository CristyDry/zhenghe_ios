//
//  RongYunHttp.h
//  Express_IOS
//
//  Created by ZhouZhenFu on 15/11/23.
//  Copyright © 2015年 LuCanAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RongYunHttp : NSObject

/**
 *  请求获取融云token
 *
 *  @param type       1为患者，2为医生
 *  @param completion 回调
 */
+ (void)loadRongYunTokenType:(NSString *)type
                      userId:(NSString *)userId
                  completion:(void(^)(NSString *token))completion;

@end
