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
{
    
}
@property (strong, nonatomic) IBOutlet SpriteImageView *spriteImageView;
@property (strong, nonatomic) IBOutlet UILabel *orderTime;
@property (strong, nonatomic) IBOutlet UILabel *goodsPrice;
@property (strong, nonatomic) IBOutlet UILabel *goodsStatus;
@property (copy, nonatomic)selectButton btnBlock;

@property (weak, nonatomic) IBOutlet UIButton *underBlackButton;
@property (weak, nonatomic) IBOutlet UIButton *underRedButton;


@end
