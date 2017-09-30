//
//  BZCityModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/25.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZCityModel : NSObject

//"provincialId" : "12",
//"id" : "100",
//"cityName" : "蚌埠市",
//"cityNo" : "552",
//"isNewRecord" : false
@property (nonatomic, copy) NSString *provincialId; // 省份id

@property (nonatomic, copy) NSString *ID;           // 城市id

@property (nonatomic, copy) NSString *cityName;     // 城市名称

@property (nonatomic, copy) NSString *cityNo;       // 城市号

@property (nonatomic, assign) BOOL isNewRecord;     

@end
