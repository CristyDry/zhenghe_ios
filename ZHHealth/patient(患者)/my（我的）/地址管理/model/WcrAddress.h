//
//  WcrAddress.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WcrAddress : NSObject

@property (nonatomic, strong) NSString *icon;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *region;     // 地区

@property (nonatomic, strong) NSString *address;    // 详细地址

+(NSArray*)createObj;

@end
