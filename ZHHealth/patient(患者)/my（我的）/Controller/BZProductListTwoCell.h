//
//  BZProductListTwoCell.h
//  ZHHealth
//
//  Created by pbz on 16/1/6.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZProductDetailInfosModel.h"
#import "BZProductDetailADPictureModel.h"

@interface BZProductListTwoCell : UITableViewCell

@property (nonatomic,strong)  BZProductDetailInfosModel *productDetailInfosModel;
//@property (nonatomic,strong)  BZProductDetailADPictureModel *adModel;
@property (nonatomic,strong)  NSString *ADpic;
@end
