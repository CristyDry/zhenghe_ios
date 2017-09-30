//
//  BZCollectArticleListModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/17.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZCollectArticleListModel : NSObject
/** 收藏时间*/
@property (nonatomic, copy) NSString *updateDate;
/** 文章内容*/
@property (nonatomic, copy) NSString *content;
/** 文章id*/
@property (nonatomic, copy) NSString *ID;
/** 文章图片*/
@property (nonatomic, copy) NSString *avatar;
/** 文章题目*/
@property (nonatomic, copy) NSString *title;
/** 状态*/
@property (nonatomic, copy) NSString *status;
/** 创建时间*/
@property (nonatomic, copy) NSString *createDate;
/** 收藏号*/
@property (nonatomic, copy) NSString *collectNum;
/** 文章出处*/
@property (nonatomic, copy) NSString *publish;
/** 是否新收藏的*/
@property (nonatomic, assign) BOOL isNewRecord;

@end
