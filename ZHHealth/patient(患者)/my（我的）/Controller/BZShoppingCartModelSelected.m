//
//  BZShoppingCartModelSelected.m
//  ZHHealth
//
//  Created by pbz on 16/1/4.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import "BZShoppingCartModelSelected.h"
// 文件路径
#define file [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BZAddressModelArraysSelected.data"]
@implementation BZShoppingCartModelSelected

MJExtensionCodingImplementation
// 归档
+ (void)encode:(NSMutableArray *) addressModelArray{
    [NSKeyedArchiver archiveRootObject:addressModelArray toFile:file];
}
// 解档
+ (NSMutableArray *)decode{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}

@end
