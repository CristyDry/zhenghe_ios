//
//  BZRecordBloodController.m
//  ZHHealth
//
//  Created by pbz on 15/12/19.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZRecordBloodController.h"

@interface BZRecordBloodController ()<UITextFieldDelegate>
@property (nonatomic,strong)  UITextField *sbpTextField; // 收缩压
@property (nonatomic,strong)  UITextField *dpbTextField; // 舒张压
@end

@implementation BZRecordBloodController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBackItem];
    self.view.backgroundColor = [UIColor colorWithRGB:245 G:245 B:245];
    self.navigationItem.title = @"记录血压";
    [self setCustomUI];
    [_sbpTextField becomeFirstResponder];
    
}
- (void)setCustomUI{
    [self initBaseView:75 withLeftName:@"收缩压" withPlaceholder:@"请输入收缩压" withTag:1];
    [self initBaseView:124 withLeftName:@"舒张压" withPlaceholder:@"请输入舒张压" withTag:2];
    // 保存
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, kMainWidth - 60, 45)];
    saveBtn.backgroundColor = kNavigationBarColor;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    saveBtn.layer.cornerRadius = 3;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    // 删除
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(saveBtn.frame) + 20, kMainWidth - 60, 45)];
    deleteBtn.backgroundColor = [UIColor redColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    deleteBtn.layer.cornerRadius = 3;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
}
// 保存
- (void)saveClick{
  
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"bpId"] = _bpId;
    args[@"patientId"] = _patientId;
    if (_dpbTextField.text.length && _sbpTextField.text.length) {
        args[@"sbp"] = _sbpTextField.text;
        args[@"dbp"] = _dpbTextField.text;
        [httpUtil doPostRequest:@"api/medicalApiController/addBloodPressure" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                // 跳转控制器
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"血压不能为空";
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}
// 删除
- (void)deleteClick{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = _bpId;
    [httpUtil doPostRequest:@"api/medicalApiController/delBloodPressureRecord" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            // 跳转控制器
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)initBaseView:(CGFloat )pointY withLeftName:(NSString *)leftName withPlaceholder:(NSString *)Placeholder withTag:(NSInteger) tag{
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, pointY, kMainWidth, 50)];
    baseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    baseView.layer.borderWidth = 1;
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    CGFloat height = baseView.bounds.size.height;
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, height)];
    leftLabel.textAlignment = 0;
    leftLabel.text = leftName;
    [baseView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 85, 0, 70, height)];
    rightLabel.textAlignment = 2;
    rightLabel.text = @"mmhg";
    [baseView addSubview:rightLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(kMainWidth - 185, 0, 100, height)];
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = Placeholder;
    [baseView addSubview:textField];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    if (tag == 1) {
        _sbpTextField = textField;
        _sbpTextField.text = _sbp;
    }else{
        _dpbTextField = textField;
        _dpbTextField.text = _dpb;
    }

}

@end
