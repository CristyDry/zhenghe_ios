//
//  BZAddHeartRateController.m
//  ZHHealth
//
//  Created by pbz on 15/12/21.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZAddHeartRateController.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface BZAddHeartRateController ()<UIPickerViewDelegate ,UIPickerViewDataSource>
@property (nonatomic,strong)  UITextField *heartRate;
@property (nonatomic,strong)  UIButton *sceneBtn;
@property (nonatomic,strong)  UIPickerView *pickerView;
@property (nonatomic,strong)  NSArray *array;
@property (nonatomic,strong)  TPKeyboardAvoidingScrollView *tpk;
@end

@implementation BZAddHeartRateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    self.view.backgroundColor = [UIColor colorWithRGB:245 G:245 B:245];
    self.navigationItem.title = @"心率记录";

    [self setCustomUI];
}

- (void)setCustomUI{
    
    _tpk = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    _tpk.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tpk];
    
    [self initBaseView:75 withLeftName:@"心率" withPlaceholder:@"输入心率值" withTag:1];
    [self initBaseView:124 withLeftName:@"测量情景" withPlaceholder:nil withTag:2];
    // 保存
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 200, kMainWidth - 60, 45)];
    saveBtn.backgroundColor = kNavigationBarColor;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    saveBtn.layer.cornerRadius = 3;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [_tpk addSubview:saveBtn];
    // pickview
    _array = @[@"静息心率",@"运动前",@"运动后"];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(saveBtn.frame) +10, kMainWidth, kMainWidth * 0.5)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_tpk addSubview:_pickerView];
    
}
// 保存
- (void)saveClick{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"patientId"] = _patientId;
    NSLog(@"_heartRate.text:%@",_heartRate.text);
    if (_heartRate.text.length) {
        args[@"heartRate"] = _heartRate.text;
        args[@"scene"] = _sceneBtn.titleLabel.text;
        [httpUtil doPostRequest:@"api/medicalApiController/addHeartRate" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                // 跳转控制器
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"心率不能为空";
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
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
    
    if (tag == 1) {
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 85, 0, 70, height)];
        rightLabel.textAlignment = 2;
        rightLabel.text = @"BMP";
        [baseView addSubview:rightLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(kMainWidth - 185, 0, 100, height)];
        textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = Placeholder;
        textField.textAlignment = 2;
        [baseView addSubview:textField];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        _heartRate = textField;
        [textField becomeFirstResponder];
    }else if (tag == 2){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 145, 0, 70, height)];
        [btn setTitle:@"静息心率" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sceneBtn = btn;
        [baseView addSubview:btn];
    }
}

#pragma mark - pickerViewDelegate
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kMainWidth;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *str = [_array objectAtIndex:row];
    [_sceneBtn setTitle:str forState:UIControlStateNormal];
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        return [_array objectAtIndex:row];
    
}
@end
