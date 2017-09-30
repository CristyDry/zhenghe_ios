//
//  WcrFunction.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/10.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WcrFunction : NSObject

@property (nonatomic, strong) NSString *iconName;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *detail;

+(NSArray*)createObj;

@end
