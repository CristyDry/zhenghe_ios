//
//  HLTDiagnoseViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTDiagnoseViewController.h"
#import "HLTPetitionerViewController.h"
#import "HLTGroupViewController.h"
#import "HLTMycardViewController.h"
#import "HLTSearchViewController.h"
#import "HLTDiagnose.h"
#import "HLTSearch.h"
#import "HLTSearchCell.h"
#import "HLTPDetailController.h"
#import "MyPrescriptionViewController.h"

@interface HLTDiagnoseViewController () <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIImageView *imageview;//上部按钮背景
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *bgView ;


@property (nonatomic, strong) NSMutableArray *selectArray;//按钮点击状态数组
@property (nonatomic, strong) NSMutableArray *groupArray;//分组列表数组
@property (nonatomic, strong) NSMutableArray *nameArray;//分组患者数组
@property (nonatomic, strong) UIButton *button;//分组前部按钮

@property (nonatomic, strong) UITableView *tableView;//tableview
@property (nonatomic, strong) UITextField *textfield;//搜索框

@end

@implementation HLTDiagnoseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求分组数据
    [self CreateDataList];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![HLTLoginResponseAccount isLogin]) {
        HLTLoginViewController * login = [[HLTLoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
    //添加搜索框
    [self addSearchBar];
    //添加上部按钮
    [self addHeadView];
    
}


#pragma mark - 添加搜索框
-(void)addSearchBar
{ 
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, 50)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, kMainWidth-20, 30)];
    [_textfield textFieldWithPlaceholder:@"搜索" andFont:KFont - 4 andSecureTextEntry:NO];
    UIImage *leftImage = [UIImage imageFileNamed:@"iconfont-sousuo" andType:YES];
    UIButton *leftView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftView setImage:leftImage forState:0];
    leftView.userInteractionEnabled = NO;
    _textfield.leftView = leftView;
    _textfield.leftViewMode = UITextFieldViewModeAlways;
    _textfield.userInteractionEnabled = NO;
    UIImage *image = [UIImage imageFileNamed:@"搜索框" andType:YES];
    _textfield.background = image;
    [_bgView addSubview:_textfield];
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:_textfield.frame];
    [searchButton addTarget:self action:@selector(searchButtonAction)];
    [_bgView addSubview:searchButton];
    
}

#pragma mark - 搜索
-(void)searchButtonAction {
    
    // 搜索  SearchViewController
    HLTSearchViewController *searchVC = [[HLTSearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma mark - 添加上部分按钮
-(void)addHeadView
{
    NSArray * textArr = @[@"用户申请",@"分组管理",@"我的名片",@"我的处方"];
    NSArray * imageArr = @[@"图层-13",@"iconfont-automatic-configuration",@"iconfont-zhanghu",@"icon_ChuFang"];
    
//    CGFloat width = (kMainWidth-30*2)/5;
    CGFloat width = (kMainWidth - 30*2 - 90)/4;
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, width +70)];
    
    
//    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, width+50)];
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, width + 60)];
    _imageview.backgroundColor = [UIColor whiteColor];
    _imageview.userInteractionEnabled = YES;
    [_headView addSubview:_imageview];
    
    
    for (int i = 0; i<4; i++)
    {
//        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(30+i*(width+width), 10, width, width)];
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(30+i*(width+30), 10, width, width)];
        button.tag = 100+i;
        [button addTarget:self action:@selector(headButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [_imageview addSubview:button];
        
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(25+i*(width+width), CGRectGetMaxY(button.frame)+8, width+10, 20)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(25+i*(width+30), CGRectGetMaxY(button.frame)+8, width+10, 20)];
        label.text = textArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [_imageview addSubview:label];
    }
    
}

#pragma mark - 上部按钮点击事件
-(void)headButton:(UIButton *)button
{
    switch (button.tag - 100)
    {
        case 0:
        {
            HLTPetitionerViewController * petitioner = [[HLTPetitionerViewController alloc] init];
            petitioner.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:petitioner animated:NO];
        }
            break;
        case 1:
        {
            HLTGroupViewController * group = [[HLTGroupViewController alloc] init];
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:NO];
        }
            break;
        case 2:
        {
            HLTMycardViewController * myCard = [[HLTMycardViewController alloc] init];
            myCard.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myCard animated:NO];
        }
            break;
        case 3:
        {
            MyPrescriptionViewController *MyPrescriptionVC = [GetPrescriptionStoryboard instantiateViewControllerWithIdentifier:@"MyPrescriptionViewController"];
            [self.navigationController pushViewController:MyPrescriptionVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 分组列表数组数据
-(void)CreateDataList
{
    self.groupArray = [[NSMutableArray alloc] init];
    self.nameArray = [[NSMutableArray alloc] init];
    self.selectArray = [[NSMutableArray alloc] init];
    
    //将所需的参数id解档出来
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/patientGroup" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            weakSelf.groupArray = [HLTDiagnose mj_objectArrayWithKeyValuesArray:responseMd.response];
            [self addTableView];
        }
    }];
}


#pragma mark - 添加tableview
-(void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bgView.frame)+15, kMainWidth, kMainHeight-_bgView.maxY_wcr-15) style:UITableViewStylePlain];
    _tableView.backgroundColor = kBackgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    _tableView.tableHeaderView = _headView;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HLTDiagnose *hlt = [_groupArray objectAtIndex:section];
    
    if (!hlt.show) {
        return 0;
    }
    return hlt.name.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = @"GroupCell";
    HLTSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[HLTSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    HLTDiagnose *hlt = [_groupArray objectAtIndex:indexPath.section];
    cell.huanzheModel = [hlt.name objectAtIndex:indexPath.row];
  
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 35;
}
//自定义的header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HLTDiagnose * diagnoseModel = [_groupArray objectAtIndex:section];
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 35)];
    headView.backgroundColor =[UIColor whiteColor];
    
    _button= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 34)];
    //设置titile
    [_button setTitle:[NSString stringWithFormat:@"%@ (%@)",diagnoseModel.grouping,diagnoseModel.count] forState:UIControlStateNormal];
    _button.titleLabel.font=[UIFont systemFontOfSize:15];
    [_button setTitleColor:kBlackColor forState:UIControlStateNormal];
    _button.tag=section;
    
    
    HLTDiagnose *hlt = [_groupArray objectAtIndex:section];
    BOOL close = hlt.show;
    
    if (!close)
    {
        [_button setImage:[UIImage imageNamed:@"icon_1"] forState:UIControlStateNormal];
    }
    else
    {
        [_button setImage:[UIImage imageNamed:@"icon_2"] forState:UIControlStateNormal];
    }
    
    //由于按钮的标题，
    //4个参数是上边界，左边界，下边界，右边界。
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [_button setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    // 点击事件
    [_button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_button];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(10, _button.maxY_wcr, kMainWidth-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.4;
    [headView addSubview:line];
    
    return headView;
}
-(void)click:(UIButton *)sender
{
    
    //是否展示
    HLTDiagnose *hlt = [_groupArray objectAtIndex:sender.tag];
    hlt.show = !hlt.show;
    
    //刷新sections
    [_tableView reloadData];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    HLTDiagnose *hlt = [_groupArray objectAtIndex:indexPath.section];
    HLTPDetailController * pDetail = [[HLTPDetailController alloc] init];
    pDetail.huanzheModel =[hlt.name objectAtIndex:indexPath.row];
    pDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pDetail animated:YES];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textfield resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
