//
//  BZAllOrderModel.m
//  ZHHealth
//
//  Created by pbz on 15/12/31.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZAllOrderModel.h"

@implementation BZAllOrderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"items" : [productInfos class]};
}
@end
@implementation productInfos
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}
@end


