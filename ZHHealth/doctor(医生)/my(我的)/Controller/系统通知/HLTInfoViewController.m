//
//  HLTInfoViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTInfoViewController.h"
#import "HLTLabel.h"
#import "HLTInfoModel.h"
#import "HLTInfoCell.h"
#import "HLTInfoDetailController.h"

@interface HLTInfoViewController ()  <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation HLTInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    //添加左边返回按钮
    [self addLeftBackItem];
    //中间标题
    [self addTitleView];
    [self requestInfoData];
}

#pragma mark - 中间标题
- (void)addTitleView{
    
    HLTLabel * titleLabel = [[HLTLabel alloc] init];
    [titleLabel useLabel:@"系统通知"];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 请求系统消息
-(void)requestInfoData
{
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:45];
    
    NSInteger userState = [CoreArchive intForKey:@"userState"];

    
    //患者端
    if (userState == kPatient)
    {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        LoginResponseAccount *account = [LoginResponseAccount decode];
        args[@"id"] = account.Id;
        args[@"type"] = [NSString stringWithFormat:@"1"];
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/systemMessage" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSelf.dataArray = [HLTInfoModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [self createtableview];
            }
        }];
    }
    else//医生端
    {    //将所需的参数id解档出来
        HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"id"] = account.Id;
        args[@"type"] = [NSString stringWithFormat:@"2"];
        __weak typeof(self) weakSelf = self;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/systemMessage" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                weakSelf.dataArray = [HLTInfoModel mj_objectArrayWithKeyValuesArray:responseMd.response];
                [self createtableview];
            }
        }];
    }
}

#pragma mark - 根据dataArray创建view
-(void)createtableview
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight+10 , kMainWidth, kMainHeight-KTopLayoutGuideHeight) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.rowHeight = 140;
    _tableview.tableFooterView = [[UIView alloc] init];
    _tableview.backgroundColor = kBackgroundColor;
    [self.view addSubview:_tableview];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(HLTInfoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * infoId = @"infoCell";
    HLTInfoCell * infoCell = [tableView dequeueReusableCellWithIdentifier:infoId];
    if (infoCell == nil)
    {
        infoCell = [[HLTInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoId];
    }
    
    infoCell.backgroundColor = kBackgroundColor;
    infoCell.infoModel = _dataArray[indexPath.row];
    
    return infoCell;
     
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableview deselectRowAtIndexPath:indexPath animated:NO];
    
    HLTInfoModel * infomodel = _dataArray[indexPath.row];
    
    HLTInfoDetailController * infoDetail = [[HLTInfoDetailController alloc] init];
    infoDetail.infoModel = _dataArray[indexPath.row];
    infoDetail.title =infomodel.title;
    [self.navigationController pushViewController:infoDetail animated:NO];
    
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
