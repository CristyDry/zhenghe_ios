//
//  BZHeartRateMonModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/19.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZHeartRateMonModel : NSObject
/** TeamFinanceModel 数组*/
@property (nonatomic,strong) NSMutableArray *dataSource;
/** 年*/
@property (nonatomic,copy) NSString *year;
/**月*/
@property (nonatomic,copy) NSString *month;
/**标题*/
@property (nonatomic,copy) NSString *title;

/**
 *  根据年月日初始化一个月的
 *
 *  @param year  年
 *  @param month 月
 *
 *  @return
 */
- (id)initWithYear:(NSString *)year month:(NSString *)month;
@end
