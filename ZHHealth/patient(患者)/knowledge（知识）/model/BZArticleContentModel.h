//
//  BZArticleContentModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZArticleContentModel : NSObject
/** 文章图片*/
@property (nonatomic, copy) NSString *avatar;
/** 文章内容*/
@property (nonatomic, copy) NSString *content;
/** 文章id*/
@property (nonatomic, copy) NSString *ID;
/** 文章标题*/
@property (nonatomic, copy) NSString *title;
/** 文章出处*/
@property (nonatomic, copy) NSString *publish;
/** 是否已收藏*/
@property (nonatomic, copy) NSString *isCollect;
/** 文章创建时间*/
@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *url;

@end
