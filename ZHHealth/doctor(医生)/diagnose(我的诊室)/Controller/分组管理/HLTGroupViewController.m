//
//  HLTGroupViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTGroupViewController.h"
#import "HLTNewGroupViewController.h"
#import "HLTGroup.h"
#import "HLTEditGroupController.h"

@interface HLTGroupViewController ()  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *afterDataArray;
@property (nonatomic, strong) UIView * bigView;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UILabel *label;

@end

@implementation HLTGroupViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestPetitionerdata];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分组管理";
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addRightButton];
   
}

#pragma mark - 右边新建按钮
-(void)addRightButton
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"新建" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(createNew) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
 
}

#pragma mark - 新建按钮点击事件
-(void)createNew
{
    HLTNewGroupViewController * newGroup = [[HLTNewGroupViewController alloc] init];
    [self.navigationController pushViewController:newGroup animated:NO];
    
}

#pragma mark - 请求患者数据
-(void)requestPetitionerdata
{
    _afterDataArray = [[NSMutableArray alloc] init];
    //将所需的参数id解档出来
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/manageGroup" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            weakSelf.dataArray = [HLTGroup mj_objectArrayWithKeyValuesArray:responseMd.response];
            for (HLTGroup * group in weakSelf.dataArray) {
                
                if (![group.groupName isEqualToString:@"默认分组"]) {
                   [_afterDataArray addObject:group];
                }
            }
            [self createBackImageview];
    
        }
    }];
}

#pragma mark - 上部imageview
-(void)createBackImageview
{
    
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, 50)];
    _bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bigView];
    
    
    CGFloat xPoint = 20.0;
    CGFloat yPoint = 10.0;
    CGFloat width = 200.0;
    CGFloat height = 30.0;
    
    UILabel * patientLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [_bigView addSubview:patientLabel];
    
    for (HLTGroup * group in _dataArray) {
        if ([group.groupName isEqualToString:@"默认分组"]) {
           patientLabel.text = [NSString stringWithFormat:@"%@ (%@)",group.groupName,group.count];
        }
    }
    
   
    UIImageView * lineImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, _bigView.maxY_wcr, kMainWidth, 1)];
    lineImageview.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineImageview];
    
    if (_afterDataArray.count  >0)
    {
        [self addCustomUI];
    }else{
        [_tableview removeFromSuperview];
        [_label removeFromSuperview];
    }
}


#pragma mark - 自定义分组
-(void)addCustomUI
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, _bigView.maxY_wcr +15, kMainWidth-20.0, AUTO_MATE_HEIGHT(30))];
    _label.text = @"自定义分组";
    [self.view addSubview:_label];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, _label.maxY_wcr+10, kMainWidth,kMainHeight- KTopLayoutGuideHeight -_label.maxY_wcr) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = kBackgroundColor;
    _tableview.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableview];
    
}

#pragma mark - tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _afterDataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellId = @"groupCell";
    UITableViewCell * groupCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!groupCell) {
        groupCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    HLTGroup * group = _afterDataArray[indexPath.row];
    
    UILabel * groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kMainWidth-20, 30)];
    groupLabel.text = [NSString stringWithFormat:@"%@ (%@)",group.groupName,group.count];
    
    [groupCell.contentView addSubview:groupLabel];
    
    return groupCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HLTGroup * group = _afterDataArray[indexPath.row];
    HLTEditGroupController * editGroup = [[HLTEditGroupController alloc] init];
    editGroup.groupModel = group;
    [self.navigationController pushViewController:editGroup animated:YES];
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
