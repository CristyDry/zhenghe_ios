//
//  WcrSettingTitle.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrSettingTitle.h"

@implementation WcrSettingTitle

+(NSArray *)createTitles {
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *titleStrings = @[@"免责申明",@"关于我们",@"检测新版本"];
    for (int i = 0; i < titleStrings.count; i++) {
        WcrSettingTitle *setting = [[WcrSettingTitle alloc]init];
        setting.titleString = titleStrings[i];
        if ([setting.titleString isEqualToString:@"检测新版本"]) {
            // 获取应用程序的版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            // 版本号
            NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            setting.detail = [NSString stringWithFormat:@"当前版本%@",version];
        }
        [array addObject:setting];
    }
    
    return array;
}

@end
