//
//  WcrSettingTitle.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WcrSettingTitle : NSObject

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) NSString *detail;

+(NSArray*)createTitles;

@end
