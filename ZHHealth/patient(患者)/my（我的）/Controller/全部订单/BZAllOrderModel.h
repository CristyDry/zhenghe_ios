//
//  BZAllOrderModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/31.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class productInfos;
@interface BZAllOrderModel : NSObject
//{
//    "id" : "4e2ea610b2564d1eb19b67e3e4df079e",
//    "status" : "1",
//    "phone" : "13535242611",
//    "totalAmount" : "84.0",
//    "createDate" : "2015-12-30 10:24:36",
//    "isNewRecord" : false,
//    "address" : "北京北京市东城区hahaha",
//    "updateDate" : "2015-12-30 10:24:36",
//    "items" : [
//               {
//                   "id" : "734410659fd84358a61014954bd51e40",
//                   "productId" : "933c0fe73b8c49c0a5a9a9bb8d2af2c1",
//                   "count" : "6",
//                   "createDate" : "2015-12-30 10:24:37",
//                   "productName" : "银翘解毒丸（浓缩丸",
//                   "standard" : "每10丸重1.5克",
//                   "realityPrice" : "14",
//                   "productPic" : "http:\/\/112.124.62.66:8088\/zhenghe\/userfiles\/1\/files\/zhenghe\/zhengheCarousel\/2015\/11\/3.jpg",
//                   "isNewRecord" : false,
//                   "originalPrice" : "14",
//                   "updateDate" : "2015-12-30 10:24:37",
//                   "orderId" : "4e2ea610b2564d1eb19b67e3e4df079e",
//                   "orderItemNo" : "1451442277012",
//                   "sumPrice" : "84"
//               }
//               ],
//    "parentOrderNo" : "1451442276992",
//    "name" : "oneday",
//    "patientId" : "724a6991e22e4a438189fc51f5a4ecb4"
//}
@property (nonatomic, copy) NSString *ID;// 订单id

@property (nonatomic, copy) NSString *status;// 订单状态

@property (nonatomic, copy) NSString *phone;// 电话

@property (nonatomic, copy) NSString *totalAmount;// 总金额

@property (nonatomic, copy) NSString *createDate;// 创建时间

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *address;// 地址

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, strong) NSArray<productInfos *> *items;

@property (nonatomic, copy) NSString *parentOrderNo;// 订单号

@property (nonatomic, copy) NSString *name;// 名称

@property (nonatomic, copy) NSString *patientId;// 患者id

@property (nonatomic, copy) NSString *expressName;// 快递名称

@property (nonatomic, copy) NSString *expressNo;// 快递单号

@end

@interface productInfos : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *standard;

@property (nonatomic, copy) NSString *realityPrice;

@property (nonatomic, copy) NSString *productPic;

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *originalPrice;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *orderItemNo;

@property (nonatomic, copy) NSString *sumPrice;

@end

