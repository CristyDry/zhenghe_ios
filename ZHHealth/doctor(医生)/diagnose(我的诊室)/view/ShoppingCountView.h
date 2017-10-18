//
//  ShoppingCountView.h
//  ShoppingView
//
//  Created by soso on 15/9/21.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 增加或者减少block
 
 @param account 商品数量
 @param ID 商品Id
 @param plusBtn 增加按钮 （不可以增加的时候用于更换图片）
 @param amountTextField 增加后的数量
 */
typedef void(^PlusBlock)(NSInteger account,NSString *ID,UIButton *plusBtn,UIButton *minus,UITextField *amountTextField);
typedef void(^MinusBlock)(NSInteger account,NSString *ID,UIButton *plusBtn,UIButton *minus,UITextField *amountTextField);

@interface ShoppingCountView : UIView{
    
}
@property (nonatomic, strong)UITextField *amountTextField;
@property (nonatomic, strong)NSString *dataID;
@property (nonatomic, copy)PlusBlock plusBlock;
@property (nonatomic, copy)MinusBlock minusBlock;

@property (nonatomic , strong) UIButton *plus;
@property (nonatomic , strong) UIButton *minus;

@end
