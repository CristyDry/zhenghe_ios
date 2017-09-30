//
//  HLTDiagnose.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTDiagnose.h"

@implementation HLTDiagnose
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"name" : [huanzhe class]};
}
@end
@implementation huanzhe
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
