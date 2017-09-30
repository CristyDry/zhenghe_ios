//
//  HLTMyList.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTMyList.h"

@implementation HLTMyList

+(NSArray *)createWcrMyLists {
    
    NSArray *imageNames = @[@"iconfont-bianji-5",@"iconfont-iconfontshoucang",@"iconfont-svg45",@"iconfont-fenxiang-3",@"iconfont-yijianfankui",@"iconfont-shezhi-2"];
    
    NSArray *names = @[@"编辑资料",@"我的收藏",@"系统通知",@"分享",@"意见反馈",@"设置"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        
        HLTMyList *myList = [[HLTMyList alloc]init];
        myList.imageName = imageNames[i];
        myList.name = names[i];
        
        [array addObject:myList];
        
    }
    
    return array;
}

+(NSArray *)returnFirstLists {
    
    NSArray *imageNames = @[@"iconfont-bianji-5",@"iconfont-iconfontshoucang"];
    
    NSArray *names = @[@"编辑资料",@"我的收藏"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        HLTMyList *myList = [[HLTMyList alloc]init];
        myList.imageName = imageNames[i];
        myList.name = names[i];
        [array addObject:myList];
    }
    
    return array;
    
}

+(NSArray *)returnSecondLists {
    NSArray *imageNames = @[@"iconfont-svg45",@"iconfont-fenxiang-3",@"iconfont-yijianfankui"];
    
    NSArray *names = @[@"系统通知",@"分享",@"意见反馈"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        HLTMyList *myList = [[HLTMyList alloc]init];
        myList.imageName = imageNames[i];
        myList.name = names[i];
        
        [array addObject:myList];
    }
    
    return array;
}

+(NSArray *)returnThirdLists {
    NSArray *imageNames = @[@"iconfont-shezhi-2"];
    
    NSArray *names = @[@"设置"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < imageNames.count; i++) {
        
        HLTMyList *myList = [[HLTMyList alloc]init];
        myList.imageName = imageNames[i];
        myList.name = names[i];
        
        [array addObject:myList];
        
    }
    
    return array;
}

@end
