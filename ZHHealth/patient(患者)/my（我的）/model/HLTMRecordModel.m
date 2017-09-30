//
//  HLTMRecordModel.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/29.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTMRecordModel.h"

@implementation HLTMRecordModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id",@"Description":@"description"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"cdList" : [cdList class]};
}
@end
@implementation cdList
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end


