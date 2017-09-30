//
//  BZChannelListModel.m
//  ZHHealth
//
//  Created by pbz on 15/12/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZChannelListModel.h"

@implementation BZChannelListModel

MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"ID":@"id"};
}
// 归档
+ (void)encode:(NSMutableArray *) account{
    NSString *doc = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [doc stringByAppendingPathComponent:@"BZChannelListModel.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:file];
}
// 解档
+ (NSMutableArray *)decode{
    NSString *doc = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [doc stringByAppendingPathComponent:@"BZChannelListModel.data"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}
@end
