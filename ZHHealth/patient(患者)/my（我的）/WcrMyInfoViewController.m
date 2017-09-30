//
//  WcrMyInfoViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrMyInfoViewController.h"
#import "WcrUserHeaderCell.h"
#import "WcrUserInfoCell.h"
#import "ModifyViewController.h"
#import "WcrAddressViewController.h"
#import "WcrModifyPasswViewController.h"
#import "BZProvinceModel.h"
#import "BZCityModel.h"
#import "BZDistrictModel.h"

@interface WcrMyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,HZAreaPickerDelegate, HZAreaPickerDatasource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *firstSectionTitles;
@property (nonatomic, strong) NSArray *firstUserInfos;
@property (nonatomic, strong) NSArray *secondSectionTitles;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic,strong)  LoginResponseAccount *account;
@property (strong, nonatomic) NSString *areaValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (nonatomic) BOOL isDatePicker;
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

@property (nonatomic,strong)  UIButton *provinceBtn;
@property (nonatomic,strong)  UIButton *cityBtn;
@property (nonatomic,strong)  UIButton *districeBtn;

@end

@implementation WcrMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _provinceBtn = [[UIButton alloc] init];
    _cityBtn = [[UIButton alloc] init];
    _districeBtn = [[UIButton alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _account = [LoginResponseAccount decode];
    // 获取省份
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/addressApiController/getProvinceList" args:nil targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.provinceArray = [BZProvinceModel mj_objectArrayWithKeyValuesArray:responseMd.response];
        }
    }];
    
    _firstSectionTitles = @[@"名字",@"性别",@"出生日期",@"所在地区"];
    
    _secondSectionTitles = @[@"地址管理",@"修改密码"];
    
    self.title = @"个人档案";
    
    [self setNavigationBarProperty];
    
    // 返回按钮
    [self addLeftBackItem];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight - 64) style:UITableViewStyleGrouped];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, 0.1f)];
}

- (void)viewWillAppear:(BOOL)animated{
    _account = [LoginResponseAccount decode];
    [self.tableView reloadData];

}
-(void)backLeftNavItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Data Source 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return _firstSectionTitles.count;
    }else {
        return _secondSectionTitles.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        WcrUserHeaderCell *cell = [[WcrUserHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.iconName = _account.avatar;
        return cell;
        
    }else if (indexPath.section == 1) {
        
        WcrUserInfoCell *cell = [[WcrUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.titleString = _firstSectionTitles[indexPath.row];
        cell.account = _account;
        return cell;
        
    }else {
        
        WcrUserInfoCell *cell = [[WcrUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.titleString = _secondSectionTitles[indexPath.row];
        
        cell.detailTF.hidden = YES;
        
        return cell;
    }
    
}

#pragma mark - Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _account = [LoginResponseAccount decode];
    if (indexPath.section == 0) {
        // 更改头像
        [SelectPhotosTools showAtController:self backImage:^(UIImage *image) {
            
            WcrUserHeaderCell *cell = (WcrUserHeaderCell*)[tableView cellForRowAtIndexPath:indexPath];
            cell.iconIV.image = image;
            NSMutableDictionary *args = [NSMutableDictionary dictionary];
            args[@"id"] = _account.Id;
            [httpUtil doUpImageRequest:@"api/ZhenghePatient/uploadAvatar" Image:image name:@"file" args:args response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    NSString *avatar = [responseMd.response objectForKey:@"avatar"];
                    _account.avatar = avatar;
                    [LoginResponseAccount encode:_account];
                    [self.tableView reloadData];
                }
            }];
            
        }];
    }else if (indexPath.section == 1) {
        WcrUserInfoCell *cell = (WcrUserInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        ModifyViewController *modifyVC = [[ModifyViewController alloc]init];
        if ([cell.titleString isEqualToString:@"名字"]) {
            
            modifyVC.title = @"修改名字";
            [self.navigationController pushViewController:modifyVC animated:YES];
            
        }else if ([cell.titleString isEqualToString:@"性别"]) {
            
            modifyVC.title = @"修改性别";
            [self.navigationController pushViewController:modifyVC animated:YES];
            
        }else if ([cell.titleString isEqualToString:@"出生日期"]) {
            _isDatePicker = YES;
            [self setPopViewWithTitle:@"出生日期"];
            
        }else if ([cell.titleString isEqualToString:@"所在地区"]) {
            // 将属性值至空
            _isDatePicker = NO;
            _provincialId = nil;
            _cityId = nil;
            _districtId = nil;
            [self setPopViewWithTitle:@"所在地区"];
        }
        
    }else {
        WcrUserInfoCell *cell = (WcrUserInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.titleString isEqualToString:@"地址管理"]) {
            WcrAddressViewController *wcrAddressVC = [[WcrAddressViewController alloc]init];
            [self.navigationController pushViewController:wcrAddressVC animated:YES];
            
        }else if ([cell.titleString isEqualToString:@"修改密码"]) {
            WcrModifyPasswViewController *modifyPassVC = [[WcrModifyPasswViewController alloc]init];
            [self.navigationController pushViewController:modifyPassVC animated:YES];
        }
    } 
}

#pragma mark - 城市、日期
-(void)setPopViewWithTitle:(NSString*)title {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:bgView];
    _bgView = bgView;
    
    UITapGestureRecognizer *tapCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancelBgView)];
    [bgView addGestureRecognizer:tapCancel];
    
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
    label.text = [NSString stringWithFormat:@"选择%@",title];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    xPoint = label.maxX_wcr;
    [self setLeftAndRightButtonWithButtonTitle:@"完成" andTag:638 andXpoint:xPoint WithSuperView:contentView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, label.maxY_wcr - 1, kMainWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:line];
    
    height = contentView.height_wcr - label.height_wcr;
    yPoint = label.maxY_wcr - 10;
    if ([title isEqualToString:@"出生日期"]) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, yPoint, kMainWidth, height)];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        //设置中文显示
        datePicker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _datePicker = datePicker;
        
        [contentView addSubview:datePicker];
        
    }else if ([title isEqualToString:@"所在地区"]) {
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
       [self.locatePicker showInView:contentView withFrame:CGRectMake(0, yPoint, kMainWidth, height)];
        
    }
    
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
-(void)tapCancelBgView {
    
    [_bgView removeFromSuperview];
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
    }else if (button.tag == 638) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"patientId"] = _account.Id;
        if (_isDatePicker) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"YYYY-MM-dd";
            NSString *timestamp = [formatter stringFromDate:_datePicker.date];
            _dateString = timestamp;
            args[@"birthday"] = _dateString;
            [httpUtil doPostRequest:@"api/ZhenghePatient/updateBirthday" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.isResultOk) {
                    _account.birthday = _dateString;
                    [LoginResponseAccount encode:_account];
                    [self.tableView reloadData];
                }
            }];
            
        }else {
            if (_provincialId.length == 0) {
                [Tools showMsgAtTop:@"未选择地区"];
                return;
            }
            
            args[@"provincialId"] = _provincialId;
            args[@"cityId"] = _cityId;
            args[@"districtId"] = _districtId;
            [httpUtil doPostRequest:@"api/ZhenghePatient/updateAddress" args:args targetVC:self response:^(ResponseModel *responseMd) {
                if (responseMd.response) {
                    _account.provinceName = _provincialName;
                    _account.cityName = _cityName;
                    _account.districtName = _districtName;
                    [LoginResponseAccount encode:_account];
                    [self.tableView reloadData];
                }
            }];
            
        }
    }
    
    [_bgView removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kWcrUserHeaderCellHight;
    }else {
        return 44.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    }else {
        return 10.0f;
    }
}

@end
