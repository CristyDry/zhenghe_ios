//
//  BZEnsureOrderController.h
//  ZHHealth
//
//  Created by pbz on 15/12/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZAddressModel.h"
#import <BaseViewControler.h>
@interface BZEnsureOrderController : BaseViewControler
@property (nonatomic,assign)  CGFloat totalCost;
@property (nonatomic,strong)  BZAddressModel *addressModel;
@property (nonatomic)  BOOL isFormAddress;
@property (nonatomic,strong)  NSString *doctorID;
@end
