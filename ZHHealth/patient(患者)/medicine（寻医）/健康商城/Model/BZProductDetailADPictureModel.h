//
//  BZProductDetailADPictureModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/8.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZProductDetailADPictureModel : NSObject
/**
 *  avatar 轮播图片
 */
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *articleId;

@property (nonatomic, copy) NSString *rank;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) BOOL isNewRecord;

@end
