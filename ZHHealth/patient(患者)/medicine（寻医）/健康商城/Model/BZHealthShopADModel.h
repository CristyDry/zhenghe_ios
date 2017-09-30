//
//  BZHealthShopADModel.h
//  ZHHealth
//
//  Created by pbz on 15/11/27.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZHealthShopADModel : NSObject

/** 广告图片*/
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *Id;
/** 商品Id*/
@property (nonatomic, copy) NSString *productId;
/** 广告图片标题*/
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *articleId;

@property (nonatomic, copy) NSString *rank;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) BOOL isNewRecord;



@end
