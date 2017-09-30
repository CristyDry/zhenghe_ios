//
//  BZHeartRateMonModel.m
//  ZHHealth
//
//  Created by pbz on 15/12/19.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZHeartRateMonModel.h"

@implementation BZHeartRateMonModel
- (id)initWithYear:(NSString *)year month:(NSString *)month
{
    if (self = [super init]) {
        
        _dataSource = [[NSMutableArray alloc]init];
        _year = year;
        _month = month;
        
    }
    return self;
}
@end
