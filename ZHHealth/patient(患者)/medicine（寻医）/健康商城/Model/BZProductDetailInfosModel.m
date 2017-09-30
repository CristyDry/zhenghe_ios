//
//  BZProductDetailInfosModel.m
//  ZHHealth
//
//  Created by pbz on 15/12/8.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZProductDetailInfosModel.h"

@implementation BZProductDetailInfosModel
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{

    return @{@"ID":@"id"};
}
@end
