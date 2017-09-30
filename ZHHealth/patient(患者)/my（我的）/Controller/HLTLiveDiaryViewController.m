//
//  HLTLiveDiaryViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTLiveDiaryViewController.h"
#import "HLTDiaryTableViewCell.h"
#import "HLTLiveDiary.h"
#import "HLTNewDiaryViewController.h"//新建日志
#import "LoginResponseAccount.h"

#define frame [UIScreen mainScreen].bounds

@interface HLTLiveDiaryViewController ()  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *diaryData;//数据数组
@property (nonatomic, strong) LoginResponseAccount *loginId;

@end

@implementation HLTLiveDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //添加返回按钮
    [self addLeftBackItem];
    //添加中间标题--生活日志
    [self addTitleView];
    //添加右边新建日志按钮
    [self addRightView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加tableview
    [self addTableView];
    
}

// 中间标题--生活日志
- (void)addTitleView{
    CGFloat twidth = 100;
    CGFloat theight = 44;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - twidth) * 0.5, 0, twidth, theight)];
    titleLabel.text = @"生活日志";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

// 添加右边按钮--新建生活日志
- (void)addRightView{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"u58"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(makeNewDiary) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

//新建生活日志事件
-(void)makeNewDiary{
    
    HLTNewDiaryViewController * newDiary = [[HLTNewDiaryViewController alloc] init];
    [self.navigationController pushViewController:newDiary animated:NO];
    
}

#pragma mark - 获取病人的生活日志
-(void)getDiaryDataJson
{
    NSMutableDictionary * args = [NSMutableDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    args[@"Id"] = self.loginId;
    [httpUtil doPostRequest:@"api/medicalApiController/getLifeLog" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk)
        {
            weakSelf.diaryData = [HLTLiveDiary mj_objectArrayWithKeyValuesArray:responseMd];
            
            [self addTableView];
            
        }else{
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
        
    }];
}

// 添加tableView
- (void)addTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, frame.size.height-70) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 140;
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _diaryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseID = @"diary";
    HLTDiaryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[HLTDiaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.liveDiary = _diaryData[indexPath.row];
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
