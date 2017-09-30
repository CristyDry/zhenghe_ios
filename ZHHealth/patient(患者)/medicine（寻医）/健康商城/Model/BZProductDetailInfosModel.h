//
//  BZProductDetailInfosModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/8.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZProductDetailInfosModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *salesNum;

@property (nonatomic, copy) NSString *productUnit;
/**药品名称*/
@property (nonatomic, copy) NSString *productName;
/**药品规格*/
@property (nonatomic, copy) NSString *standard;

@property (nonatomic, copy) NSString *repertoryNum;
/**产品类型*/
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *explains;
/**药品价格*/
@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) BOOL isNewRecord;

@property (nonatomic, copy) NSString *classifyName;
/**药品功效*/
@property (nonatomic, copy) NSString *pfunction;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *pclassifyId;

@property (nonatomic, copy) NSString *status;


@end
