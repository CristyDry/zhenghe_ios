//
//  LoginResponseAccount.m
//  ZHHealth
//
//  Created by pbz on 15/11/26.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "LoginResponseAccount.h"
// 文件路径
#define file [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"loginResponseAccount.data"]

@implementation LoginResponseAccount
// NSCoding实现
MJExtensionCodingImplementation

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"Id":@"id"
             };
}
// 归档
+ (void)encode:(LoginResponseAccount *) account{
    [NSKeyedArchiver archiveRootObject:account toFile:file];
}
// 解档
+ (instancetype)decode{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}
// 删除登录文件
+ (void)remove{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 判断登录文件是否存在
    if ( [fileManager fileExistsAtPath:file]) {
        [fileManager removeItemAtPath:file error:nil];
    }
}
// 判断是否已登录
+ (BOOL)isLogin{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:file]) {
        return YES;
    }else{
        return NO;
    }
}
@end
