//
//  BZAddressModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/24.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZAddressModel : NSObject
//{
//    "id" : "fac6e7de25974775877fd57e95c7b2c3",
//    "districtId" : "12",
//    "phone" : "13535242601",
//    "cityName" : "北京市",
//    "createDate" : "2015-12-03 10:36:48",
//    "isNewRecord" : false,
//    "address" : "isthis",
//    "updateDate" : "2015-12-03 10:58:53",
//    "provincialId" : "10",
//    "provinceName" : "江苏",
//    "districtName" : "顺义区",
//    "cityId" : "1",
//    "patientId" : "724a6991e22e4a438189fc51f5a4ecb4",
//    "name" : "xieqqq"
//}

@property (nonatomic, copy) NSString *ID; // 地址id

@property (nonatomic, copy) NSString *districtId;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *provincialId;

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *districtName;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *patientId;

@property (nonatomic, copy) NSString *name;

// 归档
+ (void)encode:(NSArray *) addressModelArray;
// 解档
+ (NSArray *)decode;

// 判断是否已存在地址
+ (BOOL)isAddress;






@end
