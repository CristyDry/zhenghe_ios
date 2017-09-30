//
//  BZCollectProductListModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZCollectProductListModel : NSObject
/** 产品id*/
@property (nonatomic, copy) NSString *ID;
/** 售出量*/
@property (nonatomic, copy) NSString *salesNum;
/** 产品规格*/
@property (nonatomic, copy) NSString *productUnit;
/** 产品名称*/
@property (nonatomic, copy) NSString *productName;
/** 成分*/
@property (nonatomic, copy) NSString *standard;
/** 剩余量*/
@property (nonatomic, copy) NSString *repertoryNum;
/** otc or rx */
@property (nonatomic, copy) NSString *type;
/** 物理特性*/
@property (nonatomic, copy) NSString *explains;
/** 价格*/
@property (nonatomic, assign) CGFloat price;
/** 注释*/
@property (nonatomic, assign) BOOL isNewRecord;
/** 分类名称*/
@property (nonatomic, copy) NSString *classifyName;
/** 更新日期*/
@property (nonatomic, copy) NSString *updateDate;
/** 产品功效*/
@property (nonatomic, copy) NSString *pfunction;
/** 分类id*/
@property (nonatomic, copy) NSString *pclassifyId;
/** 注释*/
@property (nonatomic, copy) NSString *remark;
/** 产品图片*/
@property (nonatomic, copy) NSString *productPic;
/** 注释*/
@property (nonatomic, copy) NSString *status;

@end
