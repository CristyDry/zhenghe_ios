//
//  BZDistrictModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/25.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZDistrictModel : NSObject
//{
//    "id" : "1010",
//    "cityId" : "104",
//    "districtName" : "郊区",
//    "isNewRecord" : false,
//    "zipCode" : "244000"
//}
@property (nonatomic, copy) NSString *ID;     // 地区id

@property (nonatomic, copy) NSString *cityId; // 城市id

@property (nonatomic, copy) NSString *districtName;// 地区名字

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *zipCode;

@end
