//
//  LoginViewController.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/13.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaseViewControler.h>

@interface LoginViewController : BaseViewControler
@property (nonatomic,copy)  NSString *phoneNumber;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *passwordTF;
@end
