//
//  HLTLoginViewController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "LoginViewController.h"
#import <BaseViewControler.h>

@interface HLTLoginViewController : BaseViewControler
@property (nonatomic,copy)  NSString *phoneNumber;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *passwordTF;
@end
