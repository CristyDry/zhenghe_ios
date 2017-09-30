//
//  WcrEditAddressViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrEditAddressViewController.h"
#import "BZProvinceModel.h"
#import "BZCityModel.h"
#import "BZDistrictModel.h"
#import "RegExpValidate.h"
#import "WcrAddressViewController.h"
@interface WcrEditAddressViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *telTF;
@property (nonatomic, strong) UIButton *selectedRegion;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic,strong)  UIView *bgView1;
@property (nonatomic,strong)  NSString *provincialName;
@property (nonatomic,strong)  NSString *districtName;
@property (nonatomic,strong)  NSString *cityName;
@property (nonatomic,strong)  NSString *provincialId;
@property (nonatomic,strong)  NSString *districtId;
@property (nonatomic,strong)  NSString *cityId;
@property (nonatomic,strong)  NSMutableArray *provinceArray;// 存省份模型的数组
@property (nonatomic,strong)  NSMutableArray *cityArray;    // 存城市的模型数组
@property (nonatomic,strong)  NSMutableArray *districtArray;// 地区的模型数组
@property (nonatomic,strong)  UIScrollView *city;
@property (nonatomic,strong)  UIScrollView *district;
@property (nonatomic,strong)  LoginResponseAccount *account;
@property (nonatomic,strong)  UIButton *provinceBtn;
@property (nonatomic,strong)  UIButton *cityBtn;
@property (nonatomic,strong)  UIButton *districeBtn;

@end

@implementation WcrEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _provinceBtn = [[UIButton alloc] init];
    _cityBtn = [[UIButton alloc] init];
    _districeBtn = [[UIButton alloc] init];
    _account = [LoginResponseAccount decode];
    // 获取省份
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/addressApiController/getProvinceList" args:nil targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.provinceArray = [BZProvinceModel mj_objectArrayWithKeyValuesArray:responseMd.response];
        }
    }];
    
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    if (_isFromCell) {
        self.title = @"编辑收货地址";
        [self addRightBarButtom];
    }else{
        self.title = @"新建收货地址";
    }
    
    [self customEditAddressView];
}

#pragma mark - 删除地址
-(void)addRightBarButtom {
    // 删除
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton buttonWithTitle:@"删除" andTitleColor:[UIColor whiteColor] andBackgroundImageName:nil andFontSize:KFont - 4];
    [rightButton addTarget:self action:@selector(deleteAddress)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)deleteAddress {
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = _addressModel.ID;
    [httpUtil doPostRequest:@"api/addressApiController/delAddress" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 自定义UI
-(void)customEditAddressView {
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0.0, 64, kMainWidth, kMainHeight)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.opaque = YES;
    [self.view addSubview:scrollView];
    
    CGFloat yPoint = 0.0;
    _nameTF = [self getTextFieldWithPlaceHolder:@"收货人名字" andYpoint:yPoint andSuperView:scrollView];
    if (_isFromCell) {
            _nameTF.text = _addressModel.name;
    }

    
    yPoint = _nameTF.maxY_wcr + 1;
    _telTF = [self getTextFieldWithPlaceHolder:@"手机号码" andYpoint:yPoint andSuperView:scrollView];
    if (_isFromCell) {
            _telTF.text = _addressModel.phone;
    }

    
    // 所在地区
    yPoint = _telTF.maxY_wcr + 1;
    CGFloat xPoint = 10.0f;
    CGFloat width = kMainWidth - xPoint * 2 ;
    CGFloat height = 50.0f;
    _selectedRegion = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _selectedRegion.opaque = YES;
    if (_isFromCell) {
        NSString *selectedRegion = [NSString stringWithFormat:@"%@%@%@",_addressModel.provinceName,_addressModel.cityName,_addressModel.districtName];
        [_selectedRegion setTitle:selectedRegion forState:0];
    }else{
        [_selectedRegion setTitle:@"所在地区" forState:0];
    }
    
    [_selectedRegion setTitleColor:kBlackColor forState:0];
    _selectedRegion.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _selectedRegion.titleLabel.font = [UIFont systemFontOfSize:KFont - 4];
    [_selectedRegion addTarget:self action:@selector(selectedRegionAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_selectedRegion];
 
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _selectedRegion.maxY_wcr, kMainWidth, 1)];
    line.backgroundColor = KLineColor;
    [scrollView addSubview:line];
    
    yPoint = _selectedRegion.maxY_wcr + 1;
    _addressTF = [self getTextFieldWithPlaceHolder:@"详细地址" andYpoint:yPoint andSuperView:scrollView];
    _addressTF.text = _addressModel.address;
    // 保存按钮
    xPoint = 30.0;
    yPoint = _addressTF.maxY_wcr + AUTO_MATE_HEIGHT(40);
    width = kMainWidth - xPoint * 2;
    height = AUTO_MATE_HEIGHT(35.0);
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [saveButton buttonWithTitle:@"保存" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 2];
    saveButton.opaque = YES;
    [saveButton addTarget:self action:@selector(saveAddress:)];
    [scrollView addSubview:saveButton];
    
}

#pragma mark - 保存地址
-(void)saveAddress:(UIButton*)button {
    LoginResponseAccount *account = [LoginResponseAccount decode];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];

    args[@"patientId"] = account.Id;
    args[@"address"] = _addressTF.text;
    args[@"name"] = _nameTF.text;
    if ([RegExpValidate validateMobile:_telTF.text]) {
        args[@"phone"] = _telTF.text;
        if (_isFromCell == YES) {
            // 修改地址
            args[@"provinceId"] = _addressModel.provincialId;
            args[@"cityId"] = _addressModel.cityId;
            args[@"districtId"] = _addressModel.districtId;
            args[@"id"] = _addressModel.ID;
            [httpUtil doPostRequest:@"api/addressApiController/editAddress" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else{
            if (_isFromShoppingCart == YES) {
                // 添加地址
                args[@"id"] = @"";
                args[@"provinceId"] = _provincialId;
                args[@"cityId"] = _cityId;
                args[@"districtId"] = _districtId;
                [httpUtil doPostRequest:@"api/addressApiController/addAddress" args:args targetVC:self response:^(ResponseModel *responseMd) {
                    if (responseMd.isResultOk) {
                        WcrAddressViewController *addressVC = [[WcrAddressViewController alloc] init];
                        [self.navigationController pushViewController:addressVC animated:YES];
                    }
                }];
            }else{
                // 添加地址
                args[@"id"] = @"";
                args[@"provinceId"] = _provincialId;
                args[@"cityId"] = _cityId;
                args[@"districtId"] = _districtId;
                [httpUtil doPostRequest:@"api/addressApiController/addAddress" args:args targetVC:self response:^(ResponseModel *responseMd) {
                    if (responseMd.isResultOk) {
                       
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];

            }

            }
            }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的手机号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

#pragma mark - 选择地区
-(void)selectedRegionAction:(UITextField*)textField {
 
    NSLog(@"选择地区");
    [_nameTF resignFirstResponder];
    [_telTF resignFirstResponder];
    [_addressTF resignFirstResponder];
    // 将属性值至空
    _provincialId = nil;
    _cityId = nil;
    _districtId = nil;
    [self setPopView];
    
}

#pragma mark - 城市
-(void)setPopView{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.2];
    _bgView1 = bgView;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:bgView];
    
    UITapGestureRecognizer *tapCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancelBgViews1)];
    [_bgView1 addGestureRecognizer:tapCancel];
    
    CGFloat height = AUTO_MATE_HEIGHT(300);
    CGFloat yPoint = kMainHeight;
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0.0, yPoint, kMainWidth, height)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    // 左按钮
    UIButton *leftButton = [self setLeftAndRightButtonWithButtonTitle:@"取消" andTag:637 andXpoint:0.0f WithSuperView:contentView];
    
    CGFloat xPoint = leftButton.maxX_wcr;
    CGFloat width = kMainWidth - xPoint * 2;
    height = AUTO_MATE_HEIGHT(40.0);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, 0.0, width, height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"选择城市"];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    xPoint = label.maxX_wcr;
    [self setLeftAndRightButtonWithButtonTitle:@"完成" andTag:638 andXpoint:xPoint WithSuperView:contentView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, label.maxY_wcr - 1, kMainWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:line];
    
    height = contentView.height_wcr - label.height_wcr;
    yPoint = label.maxY_wcr - 10;
  
    CGFloat yPointAre = label.maxY_wcr;
    // 省份
    UIScrollView *province = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPointAre, kMainWidth * 0.33, height)];
    for (NSInteger i = 0; i < _provinceArray.count; i++) {
        BZProvinceModel *provinceModel = _provinceArray[i];
        UIButton *provinceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 30, province.frame.size.width, 30)];
        provinceBtn.tag = i;
        [provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [provinceBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [provinceBtn addTarget:self action:@selector(selectedProvince:) forControlEvents:UIControlEventTouchUpInside];
        [provinceBtn setTitle:provinceModel.name forState:UIControlStateNormal];
        [province addSubview:provinceBtn];
        province.contentSize = CGSizeMake(0, CGRectGetMaxY(provinceBtn.frame) + 40);
    }
    
    [contentView addSubview:province];
    // 市
    UIView *separationLine1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(province.frame), yPointAre, 1, height)];
    separationLine1.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:separationLine1];
    UIScrollView *city = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(separationLine1.frame), yPointAre , kMainWidth * 0.33, height)];
    //        city.backgroundColor = [UIColor yellowColor];
    [contentView addSubview:city];
    _city = city;
    // 地区
    UIView *separationLine2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(city.frame), yPointAre, 1, height)];
    separationLine2.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:separationLine2];
    UIScrollView *district = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(separationLine2.frame), yPointAre, kMainWidth - CGRectGetMaxX(separationLine2.frame), height)];
    [contentView addSubview:district];
    _district = district;

    [bgView addSubview:contentView];
    
    [UIView animateWithDuration:0.5f animations:^{
        contentView.y_wcr = kMainHeight - height;
    }];
}
// 点击了省份,请求城市数据
- (void)selectedProvince:(UIButton *) provinceBtn{
    
    if(provinceBtn!= _provinceBtn){
        _provinceBtn.selected=NO;
        _provinceBtn=provinceBtn;
    }
    _provinceBtn.selected=YES;
    
    for (UIView *subView in _city.subviews) {
        [subView removeFromSuperview];
    }
    
    for (UIView *subView in _district.subviews) {
        [subView removeFromSuperview];
    }
    BZProvinceModel *provinceModel = _provinceArray[provinceBtn.tag];
    _provincialId = provinceModel.ID;
    _provincialName = provinceModel.name;
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"num"] = provinceModel.ID;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/addressApiController/getCityList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.cityArray = [BZCityModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            // 创建城市btn
            for (NSInteger i = 0; i < weakSelf.cityArray.count; i++) {
                BZCityModel *cityModel = weakSelf.cityArray[i];
                UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 30, _city.frame.size.width, 30)];
                cityBtn.tag = i;
                [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cityBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                [cityBtn addTarget:self action:@selector(selectedcity:) forControlEvents:UIControlEventTouchUpInside];
                [cityBtn setTitle:cityModel.cityName forState:UIControlStateNormal];
                [_city addSubview:cityBtn];
                _city.contentSize = CGSizeMake(0, CGRectGetMaxY(cityBtn.frame) + 40);
            }
        }
    }];
}
// 点击城市，请求地区数据
- (void)selectedcity:(UIButton *) cityBtn{
    if(cityBtn!= _cityBtn){
        _cityBtn.selected=NO;
        _cityBtn=cityBtn;
    }
    _cityBtn.selected=YES;
    for (UIView *subView in _district.subviews) {
        [subView removeFromSuperview];
    }
    BZCityModel *cityModel = _cityArray[cityBtn.tag];
    _cityId = cityModel.ID;
    _cityName = cityModel.cityName;
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"num"] = cityModel.ID;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/addressApiController/getDistrictList" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.districtArray= [BZDistrictModel mj_objectArrayWithKeyValuesArray:responseMd.response];
            // 创建城市btn
            for (NSInteger i = 0; i < weakSelf.districtArray.count; i++) {
                BZDistrictModel *districtModel = weakSelf.districtArray[i];
                UIButton *districtBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 30, _district.frame.size.width, 30)];
                districtBtn.tag = i;
                [districtBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [districtBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                [districtBtn addTarget:self action:@selector(selectedDistrict:) forControlEvents:UIControlEventTouchUpInside];
                [districtBtn setTitle:districtModel.districtName forState:UIControlStateNormal];
                [_district addSubview:districtBtn];
                _city.contentSize = CGSizeMake(0, CGRectGetMaxY(districtBtn.frame) + 40);
            }
        }
    }];
}
// 点击地区按钮
- (void)selectedDistrict:(UIButton *)districtBtn{
    if(districtBtn!= _districeBtn){
        _districeBtn.selected=NO;
        _districeBtn=districtBtn;
    }
    _districeBtn.selected=YES;
    
    BZDistrictModel *districtModel = _districtArray[districtBtn.tag];
    _districtId = districtModel.ID;
    _districtName = districtModel.districtName;
}
-(void)tapCancelBgViews1 {
    
    [_bgView1 removeFromSuperview];
    
}
-(UIButton*)setLeftAndRightButtonWithButtonTitle:(NSString*)buttonTittle andTag:(int)buttonTag andXpoint:(CGFloat)xPoint WithSuperView:(UIView*)superView {
    
    CGFloat width = AUTO_MATE_WIDTH(100);
    CGFloat height = AUTO_MATE_HEIGHT(40);
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, 0, width, height)];
    [button setTitle:buttonTittle forState:0];
    [button setTitleColor:[UIColor blueColor] forState:0];
    button.tag = buttonTag;
    [button addTarget:self action:@selector(dateButtonAction:)];
    
    [superView addSubview:button];
    
    return button;
}
// 取消、确定按钮
-(void)dateButtonAction:(UIButton*)button {
    if (button.tag == 637) {
        // 取消
    }else {
            if (_districtName.length == 0) {
                [Tools showMsgAtTop:@"未选择地区"];
                return;
            }else{
                 NSString *selectedRegion = [NSString stringWithFormat:@"%@%@%@",_provincialName,_cityName,_districtName];
                 [_selectedRegion setTitle:selectedRegion forState:UIControlStateNormal];
//                if (_cityName.length == 0) {
//                
//                }
//                    NSString *selectedRegion = [NSString stringWithFormat:@"%@",_provincialName];
//                    [_selectedRegion setTitle:selectedRegion forState:UIControlStateNormal];
//                }else if (_districtName.length == 0){
//                   NSString *selectedRegion = [NSString stringWithFormat:@"%@%@",_provincialName,_cityName];
//                    [_selectedRegion setTitle:selectedRegion forState:UIControlStateNormal];
//                }else {
//                   NSString *selectedRegion = [NSString stringWithFormat:@"%@%@%@",_provincialName,_cityName,_districtName];
//                    [_selectedRegion setTitle:selectedRegion forState:UIControlStateNormal];
//                }
                //    _account.provinceName = _provincialName;
                //    _account.cityName = _cityName;
                //    _account.districtName = _districtName;
                //    [LoginResponseAccount encode:_account];
                [_bgView1 removeFromSuperview];
        }
    }
}



-(UITextField*)getTextFieldWithPlaceHolder:(NSString*)placeHolder andYpoint:(CGFloat)yPoint andSuperView:(UIView*)superView{
    
    CGFloat xPoint = 1.0;
    CGFloat width = kMainWidth - xPoint * 2;
    CGFloat height = 50.0f;
    
    UITextField *nameTF = [[UITextField alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    nameTF.delegate = self;
    nameTF.opaque = YES;
    [nameTF textFieldWithPlaceholder:placeHolder andFont:KFont - 4 andSecureTextEntry:NO];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10.0, height)];
    nameTF.leftView = leftView;
    nameTF.rightView = leftView;
    nameTF.rightViewMode = UITextFieldViewModeAlways;
    nameTF.leftViewMode = UITextFieldViewModeAlways;
    
    [superView addSubview:nameTF];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, nameTF.maxY_wcr, kMainWidth, 1)];
    line.backgroundColor = KLineColor;
    [superView addSubview:line];
    
    return nameTF;
}

#pragma mark - textField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    textField.background = [UIImage imageFileNamed:@"圆角矩形-2" andType:YES];
    return YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    textField.background = nil;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_nameTF resignFirstResponder];
    [_telTF resignFirstResponder];
    [_addressTF resignFirstResponder];
    return YES;
}


@end
