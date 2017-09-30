//
//  HLTCollectModel.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLTCollectModel : NSObject

@property (nonatomic, strong) NSString *Id;//文章id
@property (nonatomic, strong) NSString *isNewRecord;//
@property (nonatomic, strong) NSString *createDate;//创建时间
@property (nonatomic, strong) NSString *updateDate;//更新时间
@property (nonatomic, strong) NSString *classifyId;//类型
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *content;//内容
@property (nonatomic, strong) NSString *collectNum;//编码
@property (nonatomic, strong) NSString *avatar;//图片
@property (nonatomic, strong) NSString *status;//
@property (nonatomic, strong) NSString *publish;//杂志


@end
