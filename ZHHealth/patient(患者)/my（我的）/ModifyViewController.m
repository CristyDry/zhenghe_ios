//
//  ModifyViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "ModifyViewController.h"

@interface ModifyViewController ()

@property (nonatomic, strong) UITextField *nameTF;

@property (nonatomic, strong) UITextField *manTF;
@property (nonatomic, strong) UITextField *womanTF;

@property (nonatomic, strong) UIButton *manButton;
@property (nonatomic, strong) UIButton *womenButton;

@property (nonatomic, strong) UIImageView *manIV;
@property (nonatomic, strong) UIImageView *womenIV;

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavigationBarProperty];
    
    [self addLeftBackItem];
    
    [self addRightBarButtom];
    
    [self customModifyView];
    
    // 限制名称的长度
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField *)textField{
    
    int count = [self isChineseCharacterAndLettersAndNumbersAndUnderScore:textField.text];
    
    if (count >= 20) {
        textField.text = [textField.text substringToIndex:count - 20 + 1];
    }
}

// 判断字符串中的中文数字字母下划线，字节的长度
-(int)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string {
    int count = 0;
    unsigned long len=string.length;
    
    for(int i=0;i<len;i++){
        unichar a=[string characterAtIndex:i];
        if (isalpha(a) || isalnum(a) || (a=='_')) {
            count += 1;
        }else if (a >= 0x4e00 && a <= 0x9fa6) {
            // 中文
            count += 2;
        }else{
            // 特殊字符
            // [Tools showMsgAtTop:@"不能输入特殊字符"];
        }
        if (count >= 20) {
            count = count + i;
            break;
        }
    }
    return count;
}

-(void)addRightBarButtom {
    
    float width = 40;
    float height = 24;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [button setTitle:@"确定" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
    [button addTarget:self action:@selector(modifyAciont)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

#pragma mark - 修改完成按钮
-(void)modifyAciont {
    LoginResponseAccount *account = [LoginResponseAccount decode];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"patientId"] = account.Id;
    if ([self.title isEqualToString:@"修改名字"]) {
       
        if (_nameTF.text.length == 0) {
            [Tools showMsgAtTop:@"未输入名字"];
        }
        if ([self checkString:_nameTF.text]) {

            return;
        }
        
        if (_nameTF.text.length < 4 ) {
            [Tools showMsgAtTop:@"最少输入4个字符"];
            return;
        }
        args[@"patientName"] = _nameTF.text;
        [httpUtil doPostRequest:@"api/ZhenghePatient/updatePatientName" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                account.patientName = _nameTF.text;
                [LoginResponseAccount encode:account];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }else if ([self.title isEqualToString:@"修改性别"]) {
        if (_manButton.selected) {
            args[@"gender"] = @"男";
            [httpUtil doPostRequest:@"api/ZhenghePatient/updateGender" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    account.gender = @"男";
                    [LoginResponseAccount encode:account];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        }else if(_womenButton.selected) {
            args[@"gender"] = @"女";
            [httpUtil doPostRequest:@"api/ZhenghePatient/updateGender" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    account.gender = @"女";
                    [LoginResponseAccount encode:account];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}

-(void)customModifyView {
    
    // 修改名字
    CGFloat yPoint = 10.0f;
    CGFloat height = 40.0f;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KTopLayoutGuideHeight + yPoint, kMainWidth, height)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UITextField *nameTF = [[UITextField alloc]initWithFrame:CGRectMake(kBorder, 0, kMainWidth - kBorder * 2, bgView.height_wcr)];
    _nameTF = nameTF;
    [nameTF textFieldWithPlaceholder:@"请输入昵称" andFont:16 andSecureTextEntry:NO];
    nameTF.backgroundColor = [UIColor clearColor];
    [bgView addSubview:nameTF];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, nameTF.maxY_wcr - 1, kMainWidth, 1)];
    line.backgroundColor = KLineColor;
    [bgView addSubview:line];
    
    if ([self.title isEqualToString:@"修改名字"]) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, bgView.maxY_wcr, kMainWidth - 20, 40)];
        label.text = @"4-20个字符，可由中英文、数字、下划线组成";
        label.textColor = kGrayColor;
        label.font = [UIFont systemFontOfSize:KFont - 6];
        [self.view addSubview:label];
        
    }else if ([self.title isEqualToString:@"修改性别"]) {
        
        bgView.height_wcr = 80;
        
        _manTF = nameTF;
        nameTF.userInteractionEnabled = NO;
        nameTF.clearButtonMode = UITextFieldViewModeNever;
        nameTF.text = @"男";
        
        _womanTF = [[UITextField alloc]initWithFrame:nameTF.frame];
        _womanTF.y_wcr = nameTF.maxY_wcr;
        _womanTF.backgroundColor = [UIColor clearColor];
        _womanTF.userInteractionEnabled = NO;
        _womanTF.text = @"女";
        [bgView addSubview:_womanTF];
        
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _womanTF.maxY_wcr - 1, kMainWidth, 1)];
        line1.backgroundColor = KLineColor;
        [bgView addSubview:line1];
        
        _manButton = [self getOneButtonWithYpoint:0 andTag:1201 andSuperView:bgView];
        _womenButton = [self getOneButtonWithYpoint:_manButton.maxY_wcr andTag:1202 andSuperView:bgView];
        UIImage *image = [UIImage imageFileNamed:@"iconfont-gou-2@3x"  andType:YES];
        
        CGFloat width = 18.0f;
        CGFloat height = 12.0f;
        CGFloat xPoint = kMainWidth - width - kBorder;
        CGFloat yPoint = (nameTF.height_wcr - height) / 2.0;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        _manIV = imageView;
        imageView.image = image;
        imageView.hidden = YES;
        imageView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:imageView];
        
        yPoint = _womenButton.y_wcr + yPoint;
        UIImageView *womenIV = [[UIImageView alloc]initWithFrame:imageView.frame];
        _womenIV = womenIV;
        womenIV.y_wcr = yPoint;
        womenIV.image = image;
        womenIV.backgroundColor = [UIColor clearColor];
        womenIV.hidden = YES;
        [bgView addSubview:womenIV];
        
    }
    
    
}

-(UIButton*)getOneButtonWithYpoint:(CGFloat)yPoint andTag:(int)buttonTag andSuperView:(UIView*)bgView{
    
    UIButton *manButton = [[UIButton alloc]initWithFrame:CGRectMake(0, yPoint, kMainWidth, bgView.height_wcr / 2.0)];
    manButton.tag = buttonTag;
    [manButton addTarget:self action:@selector(generSelected:)];
    [bgView addSubview:manButton];
    
    return manButton;
}

-(void)generSelected:(UIButton*)button {
    button.selected = !button.selected;
    if (button == _manButton) {
        _manIV.hidden = NO;
        _womenIV.hidden = YES;
        _womenButton.selected = NO;
    }else {
        _manIV.hidden = YES;
        _womenIV.hidden = NO;
        _womenButton.selected = YES;
    }
}

-(BOOL)checkString:(NSString*)string {
    
    unsigned long len=string.length;
    
    for(int i=0;i<len;i++){
        unichar a=[string characterAtIndex:i];
        if (isalpha(a) || isalnum(a) || (a=='_') || (a >= 0x4e00 && a <= 0x9fa6)) {
            
        }else{
            // 特殊字符
            [Tools showMsgAtTop:@"不能输入特殊字符"];
            
            return YES;
        }
    }
    return NO;
}

@end
