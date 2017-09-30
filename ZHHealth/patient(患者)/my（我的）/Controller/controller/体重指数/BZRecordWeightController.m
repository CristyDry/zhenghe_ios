//
//  BZRecordWeightController.m
//  ZHHealth
//
//  Created by pbz on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZRecordWeightController.h"

@interface BZRecordWeightController ()

@property (nonatomic,strong)  UITextField *heightTextField; // 身高
@property (nonatomic,strong)  UITextField *weightTextField; // 体重
@property (nonatomic,strong)  TPKeyboardAvoidingScrollView *tpk;

@end

@implementation BZRecordWeightController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBackItem];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"记录体重指数";
    [self setCustomUI];
    
}
- (void)setCustomUI{
    _tpk = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    _tpk.showsVerticalScrollIndicator = NO;
    _tpk.backgroundColor = [UIColor colorWithRGB:245 G:245 B:245];
    [self.view addSubview:_tpk];
    
    [self initBaseView:75 withLeftName:@"身高" withPlaceholder:@"请输入身高" withTag:1];
    [self initBaseView:124 withLeftName:@"体重" withPlaceholder:@"请输入体重" withTag:2];
    // 保存
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, kMainWidth - 60, 45)];
    saveBtn.backgroundColor = kNavigationBarColor;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    saveBtn.layer.cornerRadius = 3;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [_tpk addSubview:saveBtn];
    
    // 删除
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(saveBtn.frame) + 20, kMainWidth - 60, 45)];
    deleteBtn.backgroundColor = [UIColor redColor];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    deleteBtn.layer.cornerRadius = 3;
    deleteBtn.layer.masksToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [_tpk addSubview:deleteBtn];

    
}
// 保存
- (void)saveClick{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    // 病人ID
    LoginResponseAccount *account = [LoginResponseAccount decode];
    args[@"patientId"] = account.Id;
    args[@"wId"] = _weightID;
    if (_heightTextField.text.length && _weightTextField.text.length) {
        args[@"stature"] = _heightTextField.text;
        args[@"weight"] = _weightTextField.text;
        [httpUtil doPostRequest:@"api/medicalApiController/addWeight" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                // 跳转控制器
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"身高和体重不能为空";
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}
// 删除
- (void)deleteClick{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = _weightID;
    [httpUtil doPostRequest:@"api/medicalApiController/delWeightRecord" args:args targetVC:self response:^(ResponseModel *responseMd) {
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
    [_tpk addSubview:baseView];
    CGFloat height = baseView.bounds.size.height;
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, height)];
    leftLabel.textAlignment = 0;
    leftLabel.text = leftName;
    [baseView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 85, 0, 70, height)];
    rightLabel.textAlignment = 2;
    if (tag == 1) {
        rightLabel.text = @"cm";
    }else{
        rightLabel.text = @"kg";
    }
    
    [baseView addSubview:rightLabel];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(kMainWidth - 185, 0, 100, height)];
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = Placeholder;
    [baseView addSubview:textField];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    if (tag == 1) {
        _heightTextField = textField;
        _heightTextField.text = _stature;
    }else{
        _weightTextField = textField;
        _weightTextField.text = _weight;
    }
}

@end
