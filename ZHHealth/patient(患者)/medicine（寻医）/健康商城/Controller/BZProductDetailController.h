//
//  BZProductDetailController.h
//  ZHHealth
//
//  Created by pbz on 15/12/7.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZProductDetailInfosModel.h"
#import <BaseViewControler.h>

@interface BZProductDetailController : BaseViewControler
/**药品id*/
@property (nonatomic,strong)  NSString *productId;
/**保存药品详细信息的模型*/
@property (nonatomic,strong)  BZProductDetailInfosModel *productDetailInfosModel;

@end
