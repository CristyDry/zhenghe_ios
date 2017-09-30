//
//  HLTMyList.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTMyList : NSObject

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *name;

+(NSArray*)returnFirstLists;

+(NSArray*)returnSecondLists;

+(NSArray*)returnThirdLists;

@end
