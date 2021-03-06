//
//  WcrFunction.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrFunction.h"

@implementation WcrFunction

+(NSMutableArray *)createObj {
    
    NSArray *iconNames = @[@"iconfont-iconfontscan"];
    NSArray *names = @[@"扫一扫"];
    NSArray *detailes = @[@"扫描二维码申请咨询"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < iconNames.count; i++) {
        WcrFunction *function1 = [[WcrFunction alloc]init];
        function1.iconName = iconNames[i];
        function1.name = names[i];
        function1.detail = detailes[i];
        [array addObject:function1];
    }
    
    return array;
}

+(NSMutableArray *)createObjALL {
    
    NSArray *iconNames = @[@"找医生",@"专家会诊",@"iconfont-iconfontscan",@"iconfont-lumigouff580e"];
    NSArray *names = @[@"健康咨询",@"专业咨询",@"扫一扫",@"健康商城"];
    NSArray *detailes = @[@"在线健康咨询",@"电话预约指定专家",@"扫描二维码申请咨询",@"在线查询、登记药品"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < iconNames.count; i++) {
        WcrFunction *function1 = [[WcrFunction alloc]init];
        function1.iconName = iconNames[i];
        function1.name = names[i];
        function1.detail = detailes[i];
        [array addObject:function1];
    }
    
    return array;
}

+(NSMutableArray *)createObjDoc{
    NSArray *iconNames = @[@"找医生",@"专家会诊",@"iconfont-iconfontscan"];
    NSArray *names = @[@"健康咨询",@"专业咨询",@"扫一扫"];
    NSArray *detailes = @[@"在线健康咨询",@"电话预约指定专家",@"扫描二维码申请咨询"];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < iconNames.count; i++) {
        WcrFunction *function1 = [[WcrFunction alloc]init];
        function1.iconName = iconNames[i];
        function1.name = names[i];
        function1.detail = detailes[i];
        [array addObject:function1];
    }
    
    return array;
}

+(WcrFunction *) getMallFunc{
    WcrFunction *function1 = [[WcrFunction alloc]init];
    function1.iconName = @"iconfont-lumigouff580e";
    function1.name = @"健康商城";
    function1.detail = @"在线查询、登记药品";
    return function1;

}

@end
