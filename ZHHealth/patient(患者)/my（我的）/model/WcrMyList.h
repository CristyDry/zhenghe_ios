//
//  WcrMyList.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WcrMyList : NSObject

@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) NSString *name;

+(NSArray*)returnFirstLists;

+(NSArray*)returnSecondLists;

+(NSArray*)returnThirdLists;

@end
