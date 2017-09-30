//
//  WcrAddress.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrAddress.h"

@implementation WcrAddress

+(NSArray*)createObj {
    
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        
        WcrAddress *wcrAddress = [[WcrAddress alloc]init];
        wcrAddress.icon = @"患者默认头像";
        wcrAddress.name = @"Adale";
        wcrAddress.phone = @"18716325282";
        wcrAddress.region = @"广东广州市海珠区";
        wcrAddress.address = @"新港东路中州中心塔1305";
        
        [array1 addObject:wcrAddress];
    }
    return array1;
    
}

@end
