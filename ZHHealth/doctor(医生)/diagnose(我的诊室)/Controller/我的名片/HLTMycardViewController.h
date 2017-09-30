//
//  HLTMycardViewController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLTEditModel.h"
@interface HLTMycardViewController : UIViewController

@property (nonatomic, strong) UIImageView *iconImageview;
@property (nonatomic, strong) UIImageView *bigImageview;

@property (nonatomic, strong) HLTEditModel *editModel;//医生资料模型

@property (nonatomic, strong) NSString *iconURL;//图片网址


@end
