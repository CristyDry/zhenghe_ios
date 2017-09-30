//
//  RongYunHttp.m
//  Express_IOS
//
//  Created by ZhouZhenFu on 15/11/23.
//  Copyright © 2015年 LuCanAn. All rights reserved.
//

#import "RongYunHttp.h"
#import "httpUtil.h"
#import "RongYunTools.h"

@implementation RongYunHttp

+ (void)loadRongYunTokenType:(NSString *)type userId:(NSString *)userId completion:(void (^)(NSString *))completion
{
    if (userId.length < 1) {
        if (completion) {
            completion(@"");
        }
        return;
    }
    
    NSDictionary *dict = @{@"userType":type,
                           @"userId":userId};
    [httpUtil  loadDataPostWithURLString:@"api/ZhengheDoctor/getRongToken" args:dict response:^(ResponseModel *responseMd) {
        
        if (responseMd.isResultOk) {
            
            NSString *token = [responseMd.response objectForKey:@"rongToken"];
            [RongYunTools saveRongYunToken:token];
            [RongYunTools connectWithToken:token];
            if (completion) {
                  completion(token);
            }
        }
        else{
            if (completion) {
                completion(nil);
            }
        }

    }];
}

@end
