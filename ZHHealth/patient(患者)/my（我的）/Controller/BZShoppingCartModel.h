//
//  BZShoppingCartModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/28.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZShoppingCartModel : NSObject

@property (nonatomic, copy) NSString *ID;  // 购物车项id

@property (nonatomic, copy) NSString *productId; // 产品id

@property (nonatomic, copy) NSString *count; // 产品数量

@property (nonatomic, copy) NSString *createDate; // 创建时间

@property (nonatomic, copy) NSString *productName;//产品名称

@property (nonatomic, copy) NSString *standard; // 产品规格

@property (nonatomic, assign) CGFloat realityPrice; // 单件价格

@property (nonatomic, copy) NSString *productPic; // 产品图片

@property (nonatomic, assign) BOOL isNewRecord; //

@property (nonatomic, copy) NSString *updateDate; // 更新时间

@property (nonatomic, assign) CGFloat sumPrice; // 总价格

@property (nonatomic, copy) NSString *patientId; //  患者id

@property (nonatomic)  BOOL isSelected;

@end
