//
//  BZAddressModel.m
//  ZHHealth
//
//  Created by pbz on 15/12/24.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZAddressModel.h"
// 文件路径
#define file [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BZAddressModelArrays.data"]

@implementation BZAddressModel

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
// 归档
+ (void)encode:(NSArray *) addressModelArray{
    [NSKeyedArchiver archiveRootObject:addressModelArray toFile:file];
}
// 解档
+ (NSArray *)decode{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}


// 判断是否已存在地址
+ (BOOL)isAddress{
    NSArray *address = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSLog(@"address:%@",address);
    if (address.count == 0) {
        return NO;
    }else{
        return YES;
    }
}






@end
