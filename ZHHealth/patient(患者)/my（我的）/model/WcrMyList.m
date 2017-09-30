//
//  WcrMyList.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrMyList.h"

@implementation WcrMyList

+(NSArray *)createWcrMyLists {
    
    NSArray *imageNames = @[@"电子病例",@"iconfont-baoji",@"iconfont-shenghuofuwu",@"iconfont-yijianfankui",@"iconfont-cart",@"iconfont-dongtaiyemianxiaotubiao03",@"iconfont-fenxiang-3",@"iconfont-yijianfankui"];
    
    NSArray *names = @[@"电子病例",@"健康记录",@"生活日志",@"我的订单",@"购物车",@"我的收藏",@"分享",@"意见反馈"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        
        WcrMyList *myList = [[WcrMyList alloc]init];
        myList.imageName = imageNames[i];
        myList.name = names[i];
        
        [array addObject:myList];
        
    }
    
    return array;
}

+(NSArray *)returnFirstLists {
    
    NSArray *imageNames = @[@"电子病例",@"iconfont-baoji",@"iconfont-shenghuofuwu"];
    
    NSArray *names = @[@"电子病历",@"健康记录",@"生活日志"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        WcrMyList *myList = [[WcrMyList alloc]init];
        myList.imageName = imageNames[i];
        myList.name = names[i];
        [array addObject:myList];
    }
    
    return array;
    
}

+(NSArray *)returnSecondLists {
    NSArray *imageNames = @[@"iconfont-yijianfankui",@"iconfont-cart"];
    
    NSArray *names = @[@"我的订单",@"购物车"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        WcrMyList *myList = [[WcrMyList alloc]init];
        myList.imageName = imageNames[i];
        myList.name = names[i];
        
        [array addObject:myList];
    }
    
    return array;
}

+(NSArray *)returnThirdLists {
    NSArray *imageNames = @[@"iconfont-dongtaiyemianxiaotubiao03",@"iconfont-fenxiang-3",@"iconfont-yijianfankui"];
    
    NSArray *names = @[@"我的收藏",@"分享",@"意见反馈"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        
        WcrMyList *myList = [[WcrMyList alloc]init];
        myList.imageName = imageNames[i];
        myList.name = names[i];
        
        [array addObject:myList];
        
    }
    
    return array;
}


@end
