//
//  WcrUserInfoCell.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WcrUserInfoCell : UITableViewCell

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) NSString *detailString;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *detailTF;

@property (nonatomic,strong)  LoginResponseAccount *account;
@end
