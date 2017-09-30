//
//  HLTPetitionerViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTPetitionerViewController.h"
#import "HLTPatientTableViewCell.h"
#import "HLTPatient.h"

#import "LoginResponseAccount.h"

@interface HLTPetitionerViewController ()  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HLTPetitionerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者申请";
    //添加返回按钮
    [self addLeftBackItem];
    //titleview
    [self setNavigationBarProperty];
    //添加右边按钮
    [self addRightView];
    //请求患者申请数据
    [self resquestPetitionerInfos];
    
}


#pragma mark - 添加右边清除按钮
- (void)addRightView{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn setTitle:@"清除" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - 清除按钮点击事件
-(void)clearAll
{
    NSLog(@"清除");
}

#pragma mark - 请求患者申请数据
- (void)resquestPetitionerInfos{
    
    //将所需的参数id解档出来
    LoginResponseAccount * account = [LoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/patientApply" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            weakSelf.dataArray = [HLTPatient mj_objectArrayWithKeyValuesArray:responseMd.response];
            // 添加一个tableView
            [self addTableview];
        }
    }];
}

#pragma mark - 添加tableview
-(void)addTableview
{
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainWidth, kMainHeight-64) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = @"patient";
    HLTPatientTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[HLTPatientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
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
