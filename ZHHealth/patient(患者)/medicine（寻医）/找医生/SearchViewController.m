//
//  SearchViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#define kHeaderSection  40.0f
#define kFooterSection  44.0f
#define kbtnheight 45.0f
#import "SearchViewController.h"

#import "WCRDoctorDetailController.h"
#import "HWSearchBar.h"
#import "WcrDoctor.h"
#import "WcrDoctorCell.h"
#import "BZDidSearchController.h"
#import "BZProvinceModel.h"
#import "BZCityModel.h"
#import "BZFirstServicesModel.h"
#import "BZSecondServicesModel.h"
@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *statusBarView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic,strong)  HWSearchBar *searchBar;
@property (nonatomic,strong)  NSMutableArray *provinceModelArray;
@property (nonatomic,strong)  UIView *bgView;
@property (nonatomic,strong)  UIButton *provinceBtn;
@property (nonatomic,strong)  UIButton *localBtn;
@property (nonatomic,strong)  NSMutableArray *cityArray;
@property (nonatomic,strong)  UIView *bombBoxView;
@property (nonatomic,strong)  UIScrollView *scrollView1;
@property (nonatomic,strong)  UIScrollView *scrollView2;
@property (nonatomic,copy)  NSString *provincialId;
@property (nonatomic,copy)  NSString *firstServicesID;
@property (nonatomic,copy)  NSString *firstServicesname;
@property (nonatomic,copy)  NSString *cityID;
@property (nonatomic,strong)  NSMutableArray *firstServicesModelArray;
@property (nonatomic,strong)  UIButton *leftBtn;
@property (nonatomic,strong)  NSMutableArray *secoundServiceModelArray;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addLeftBackItem];
    [self initSearchBar];
    self.view.backgroundColor = kBackgroundColor;
    [self customSearchUI];

}

// 搜索框
- (void)initSearchBar{
    _searchBar = [[HWSearchBar alloc] initWithFrame:CGRectMake(30, 5, kMainWidth - 60, 34)];
    self.navigationItem.titleView = _searchBar;
    _searchBar.placeholder = @"搜索";
    _searchBar.text = _keys;
    _searchBar.delegate = self;
    _searchBar.clearsOnBeginEditing = YES;
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
}

-(void)customSearchUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight) style:UITableViewStyleGrouped];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    // 没有搜索到内容的提示
//    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KTopLayoutGuideHeight + 50, kMainWidth, 30)];
//    self.alertLabel = alertLabel;
//    self.alertLabel.hidden = YES;
//    alertLabel.text = @"亲，没有找到你想要的结果";
//    alertLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:alertLabel];
    
}

#pragma mark - TableView Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _doctorModelArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSString *cellIdentifier = @"doctorCell";
        WcrDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[WcrDoctorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    if (_doctorModelArray.count == 0) {
        _alertLabel.hidden = NO;
    }else{
        cell.doctorModel = _doctorModelArray[indexPath.row];
        _alertLabel.hidden = YES;
    }
    return cell;
}

#pragma mark - Table View Delegate 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWcrDoctorCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kHeaderSection;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
     return 0.1f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]init];
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kHeaderSection)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    [self setButtonWithName:@"全部地区" andXpoint:0.0 andSuperView:headerView andHiddenLine:NO];
    
    [self setButtonWithName:@"全部科室" andXpoint:kMainWidth / 2.0 andSuperView:headerView andHiddenLine:YES];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, headerView.height_wcr - 1, kMainWidth - kBorder, 1)] ;
    line.backgroundColor = KLineColor;
    [headerView addSubview:line];
    
    return headerView;
    
}

-(void)setButtonWithName:(NSString*)name andXpoint:(CGFloat)xPoint andSuperView:(UIView*)superView andHiddenLine:(BOOL)isHidden{
    
    CGFloat height = superView.height_wcr;
    CGFloat yPoint = 0.0;
    CGFloat width = kMainWidth / 2.0;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [button buttonWithTitle:name andTitleColor:kBlackColor andBackgroundImageName:nil andFontSize:KFont - 2];
    [button addTarget:self action:@selector(selectedItemAction:)];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    xPoint = button.maxX_wcr;
    yPoint = 10.0f;
    width = 1.0;
    height = button.height_wcr - yPoint * 2;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)] ;
    line.hidden = isHidden;
    line.backgroundColor = KLineColor;
    [superView addSubview:line];
    
    [superView addSubview:button];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WCRDoctorDetailController *doctorDetailVC = [[WCRDoctorDetailController alloc]init];
    doctorDetailVC.doctor = _doctorModelArray[indexPath.row];
    doctorDetailVC.isFormMyDoctor = NO;
    [self.navigationController pushViewController:doctorDetailVC animated:YES];
}

#pragma mark - 选择地区、科室
-(void)selectedItemAction:(UIButton*)button {
    
    
    if ([button.titleLabel.text isEqualToString:@"全部地区"]) {
        button.selected = YES;
        button.tag = 998;
        UIButton *btn999 = [self.view viewWithTag:999];
        btn999.selected = NO;
        if (_bgView) {
            [self tapCancelBgViews];
            [self  setBombBox:button];
        }else{
          [self  setBombBox:button];
        }
        // 请求全部省份
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/addressApiController/getProvinceList" args:nil targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSeaf.provinceModelArray = [BZProvinceModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                for (NSInteger i = 0; i < weakSeaf.provinceModelArray.count + 1; i++) {

                    UIButton *provinceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * kbtnheight, kMainWidth * 0.5, kbtnheight)];
                    provinceBtn.tag = i;
                    provinceBtn.layer.borderColor = [UIColor colorWithRGB:230 G:230 B:230].CGColor;
                    provinceBtn.layer.borderWidth = 1;
                    [provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [provinceBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                    [provinceBtn addTarget:self action:@selector(selectedProvince:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollView1 addSubview:provinceBtn];
                    _scrollView1.contentSize = CGSizeMake(0, CGRectGetMaxY(provinceBtn.frame));
                    if (i == 0) {
                        [provinceBtn setTitle:@"全部" forState:UIControlStateNormal];
                    }else{
                         BZProvinceModel *provinceModel = weakSeaf.provinceModelArray[i - 1];
                        [provinceBtn setTitle:provinceModel.name forState:UIControlStateNormal];
                    }
                }
            }
        }];
        
    }else if ([button.titleLabel.text isEqualToString:@"全部科室"]) {
        button.tag = 999;
        button.selected = YES;
        UIButton *btn998 = [self.view viewWithTag:998];
        btn998.selected = NO;
        if (_bgView) {
            [self tapCancelBgViews];
            [self  setBombBox:button];
        }else{
            [self  setBombBox:button];
        }
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/findFirstDepartments" args:nil targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSeaf.firstServicesModelArray = [BZFirstServicesModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                for (NSInteger i = 0; i < weakSeaf.firstServicesModelArray.count + 1; i++) {
                    
                    UIButton *serviceBtnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, i * kbtnheight, kMainWidth * 0.5, kbtnheight)];
                    serviceBtnLeft.tag = i;
                    serviceBtnLeft.layer.borderColor = [UIColor colorWithRGB:230 G:230 B:230].CGColor;
                    serviceBtnLeft.layer.borderWidth = 1;
                    [serviceBtnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [serviceBtnLeft setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                    [serviceBtnLeft addTarget:self action:@selector(selectedServceLeft:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollView1 addSubview:serviceBtnLeft];
                    _scrollView1.contentSize = CGSizeMake(0, CGRectGetMaxY(serviceBtnLeft.frame));
                    if (i == 0) {
                        [serviceBtnLeft setTitle:@"全部科室" forState:UIControlStateNormal];
                    }else{
                        BZFirstServicesModel *firstServicesModel = weakSeaf.firstServicesModelArray[i - 1];
                        [serviceBtnLeft setTitle:firstServicesModel.departmentsName forState:UIControlStateNormal];
                    }
                }
                
            }
        }];
        
  }
    
}
// 点击左边的科室
- (void)selectedServceLeft:(UIButton *) leftBtn{
    NSLog(@"%@",leftBtn.titleLabel.text);
    if(leftBtn!= _leftBtn){
        _leftBtn.selected=NO;
        _leftBtn =leftBtn;
    }
    _leftBtn.selected=YES;
    
    for (UIView *subView in _scrollView2.subviews) {
        [subView removeFromSuperview];
    }
    
    if (leftBtn.tag == 0) {
        // 点击了全部科室
        [self tapCancelBgViews];
        
    }else{
        NSInteger tag = leftBtn.tag - 1;
        BZFirstServicesModel *firstServicesModel = _firstServicesModelArray[tag];
        _firstServicesID = firstServicesModel.ID;
        _firstServicesname = firstServicesModel.departmentsName;
        //    _provincialName = provinceModel.name;
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] = firstServicesModel.ID;
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/findSecondDepartments" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSelf.secoundServiceModelArray = [BZSecondServicesModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                // 创建二级科室
                for (NSInteger i = 0; i < weakSelf.secoundServiceModelArray.count + 1; i++) {
                    UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * kbtnheight, _scrollView2.frame.size.width, kbtnheight)];
                    cityBtn.tag = i;
                    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cityBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                    cityBtn.layer.borderColor = [UIColor colorWithRGB:230 G:230 B:230].CGColor;
                    cityBtn.layer.borderWidth = 1;
                    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cityBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                    [cityBtn addTarget:self action:@selector(selecteSecoundsServices:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollView2 addSubview:cityBtn];
                    _scrollView2.contentSize = CGSizeMake(0, CGRectGetMaxY(cityBtn.frame));
                    if (i == 0) {
                        [cityBtn setTitle:@"全部科室" forState:UIControlStateNormal];
                    }else{
                        BZSecondServicesModel *secondServicesModel = weakSelf.secoundServiceModelArray[i - 1];
                        [cityBtn setTitle:secondServicesModel.departmentsName forState:UIControlStateNormal];
                    }
                }
            }
        }];
    }
}
// 设置弹框
- (void)setBombBox:(UIButton *) button{
    
    _localBtn = button;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, kMainWidth, kMainHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    [self.view addSubview:bgView];
    _bgView = bgView;
    
    UITapGestureRecognizer *tapCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancelBgViews)];
    [bgView addGestureRecognizer:tapCancel];
    
    UIView *bombBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, kMainWidth)];
    _bombBoxView = bombBoxView;
    bombBoxView.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth * 0.5, kMainWidth)];
    _scrollView1 = scrollView1;
    [bombBoxView addSubview:scrollView1];
    UIScrollView *scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(kMainWidth * 0.5, 0 , kMainWidth * 0.5, kMainWidth)];
    _scrollView2 = scrollView2;
    [bombBoxView addSubview:scrollView2];
    [bgView addSubview:bombBoxView];

}
- (void)tapCancelBgViews{
    [_bgView removeFromSuperview];
    _localBtn.enabled = YES;
}
// 点击了省份,请求城市数据
- (void)selectedProvince:(UIButton *) provinceBtn{

    if(provinceBtn!= _provinceBtn){
        _provinceBtn.selected=NO;
        _provinceBtn=provinceBtn;
    }
    _provinceBtn.selected=YES;
    
    for (UIView *subView in _scrollView2.subviews) {
        [subView removeFromSuperview];
    }

    if (provinceBtn.tag == 0) {
        // 点击了全部省份
        [self tapCancelBgViews];
        
    }else{
        NSInteger tag = provinceBtn.tag - 1;
        BZProvinceModel *provinceModel = _provinceModelArray[tag];
            _provincialId = provinceModel.ID;
        //    _provincialName = provinceModel.name;
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"num"] = provinceModel.ID;
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/addressApiController/getCityList" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
//                BZCityModel *cityModel = [[BZCityModel alloc] init];
//                cityModel.cityName = @"全部";
//                [weakSelf.cityArray addObject:cityModel];
                weakSelf.cityArray = [BZCityModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                // 创建城市btn
                for (NSInteger i = 0; i < weakSelf.cityArray.count + 1; i++) {
                    UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * kbtnheight, _scrollView2.frame.size.width, kbtnheight)];
                    cityBtn.tag = i;
                    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cityBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                    cityBtn.layer.borderColor = [UIColor colorWithRGB:230 G:230 B:230].CGColor;
                    cityBtn.layer.borderWidth = 1;
                    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [cityBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                    [cityBtn addTarget:self action:@selector(selectedcity:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollView2 addSubview:cityBtn];
                    _scrollView2.contentSize = CGSizeMake(0, CGRectGetMaxY(cityBtn.frame));
                    if (i == 0) {
                        [cityBtn setTitle:@"全部地区" forState:UIControlStateNormal];
                    }else{
                        BZCityModel *cityModel = weakSelf.cityArray[i - 1];
                        [cityBtn setTitle:cityModel.cityName forState:UIControlStateNormal];
                    }
                }
            }
        }];
    }
}
// 点击城市
- (void)selectedcity:(UIButton *)cityBtn{
    //        "keyword": "",
    //        "provincialId": "",
    //        "cityId": "",
    //        "departmentsId": ""
    [self tapCancelBgViews];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    if (cityBtn.tag == 0) {
        // 点击了某省的全部城市
        args[@"keyword"] = _searchBar.text;
        args[@"provincialId"] = _provincialId;
//        args[@"departmentsId"] = _firstServicesID;
        
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/findDoctorByCriteria" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSeaf.doctorModelArray = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [self.tableView reloadData];
            }
        }];
    }else {
        //点击了某个市
        NSInteger tag = cityBtn.tag - 1;
        BZCityModel *cityModel = _cityArray[tag];
        _cityID = cityModel.ID;
        args[@"keyword"] = _searchBar.text;
        args[@"cityId"] = cityModel.ID;
//        args[@"departmentsId"] = _firstServicesID;
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/findDoctorByCriteria" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSeaf.doctorModelArray = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [self.tableView reloadData];
            }
        }];
        
    }
}
// 点击二级科室
- (void)selecteSecoundsServices:(UIButton *) secoundBtn{
    //        "keyword": "",
    //        "provincialId": "",
    //        "cityId": "",
    //        "departmentsId": ""
    [self tapCancelBgViews];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    if (secoundBtn.tag == 0) {
        // 点击了某科室的全部科室
        args[@"keyword"] = _searchBar.text;
        args[@"provincialId"] = _provincialId;
        args[@"cityId"] = _cityID;
        args[@"firstDepartmentsId"] = _firstServicesID;
        if ([secoundBtn.titleLabel.text isEqualToString:@"全部科室"]) {
            _searchBar.text = _firstServicesname;
        }else{
            _searchBar.text = secoundBtn.titleLabel.text;
        }
      
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/findDoctorByCriteria" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSeaf.doctorModelArray = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [self.tableView reloadData];
            }
        }];
    }else {
        //点击了某个科室
        NSInteger tag = secoundBtn.tag - 1;
        BZSecondServicesModel *secondServicesModel = _secoundServiceModelArray[tag];
        args[@"keyword"] = _searchBar.text;
        args[@"provincialId"] = _provincialId;
        args[@"cityId"] = _cityID;
        args[@"secondDepartmentsId"] = secondServicesModel.ID;
        _searchBar.text = secoundBtn.titleLabel.text;
        __weak typeof(self) weakSeaf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/findDoctorByCriteria" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSeaf.doctorModelArray = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [self.tableView reloadData];
            }
        }];
        
    }


}
#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_searchBar.text.length > 0) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"keyword"] = _searchBar.text;
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/findDoctorByCriteria" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                if (responseMd.response) {
                    weakSelf.doctorModelArray = [BZDoctorModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                    [_tableView reloadData];
                }else{
                    [weakSelf.doctorModelArray removeAllObjects];
                    [self.tableView reloadData];
                }

            }
        }];
    }
    [_searchBar resignFirstResponder];
    return YES;
}

#pragma mark - tableView 在滑动的过程中，收起键盘
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar  resignFirstResponder];
}


@end
