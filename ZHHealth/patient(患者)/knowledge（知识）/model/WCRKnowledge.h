//
//  WCRKnowledge.h
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCRKnowledge : NSObject

@property (nonatomic, strong) NSString *title; // 标题

@property (nonatomic, strong) NSString *imageName; // 小图

@property (nonatomic, strong) NSString *content;   // 内容

@property (nonatomic, strong) NSString *bigImageName; // 大图

@property (nonatomic, strong) NSString *time;

+(NSArray*)createObjs;

@end
