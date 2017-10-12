//
//  OrderTableViewCell.h
//  DDShop
//
//  Created by soso on 15/10/11.
//  Copyright (c) 2015年 k6161061. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpriteImageView.h"

@class OrderTableDelgate;

typedef void(^selectButton)(UIButton *btn);

@interface OrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chuFangNumLable;
@property (weak, nonatomic) IBOutlet UILabel *chuFangStutusLable;
@property (weak, nonatomic) IBOutlet UILabel *chuFangAmountLable;
@property (weak, nonatomic) IBOutlet UILabel *chuFangTimeLable;
@property (weak, nonatomic) IBOutlet UIButton *chuFangOptionBtn;
@property (weak, nonatomic) IBOutlet SpriteImageView *spriteImageView;

@property (copy, nonatomic)selectButton btnBlock;

@end
