//
//  BZSearchResultViewController.h
//  ZHHealth
//
//  Created by pbz on 15/11/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaseViewControler.h>


@interface BZSearchResultViewController : BaseViewControler
@property (nonatomic,copy)  NSString *classifyId;
// 产品分类信息
@property (nonatomic,strong)  NSArray *classifyInfos;
@property (nonatomic)  BOOL isFormClassify;
@property (nonatomic,strong)  NSString *keys;//搜索关键字
@end
