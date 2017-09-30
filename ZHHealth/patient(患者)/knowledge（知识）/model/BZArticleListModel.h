//
//  BZArticleListModel.h
//  ZHHealth
//
//  Created by pbz on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZArticleListModel : NSObject
/** 文章id*/
@property (nonatomic, copy) NSString *ID;
/** 文章标题*/
@property (nonatomic, copy) NSString *title;
/** 文章图片*/
@property (nonatomic, copy) NSString *avatar;
@end
