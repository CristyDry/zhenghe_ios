//
//  WcrEditAddressViewController.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZAddressModel.h"
@interface WcrEditAddressViewController : UIViewController

@property (nonatomic) BOOL isFromCell;
@property (nonatomic) BOOL isFromShoppingCart;
@property (nonatomic, strong) BZAddressModel *addressModel;

@end
