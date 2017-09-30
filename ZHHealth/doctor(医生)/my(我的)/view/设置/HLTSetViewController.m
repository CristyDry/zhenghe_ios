//
//  HLTSetViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTSetViewController.h"
#import "HLTLabel.h"

#import "WcrSettingCell.h"
#import "WcrAboutUSViewController.h"
#import "WcrStatementViewController.h"
#import "HLTLoginViewController.h"

@interface HLTSetViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;
@end

@implementation HLTSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加左边返回按钮
    [self addLeftBackItem];
    //中间标题
    [self addTitleView];
    
    _titles = [WcrSettingTitle createTitles];
    self.view.backgroundColor  = kBackgroundColor;
    //UI界面
    [self customSettingUI];
}

#pragma mark - 中间标题
- (void)addTitleView{
    
    HLTLabel * titleLabel = [[HLTLabel alloc] init];
    [titleLabel useLabel:@"设置"];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 总UI
-(void)customSettingUI {
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight+20, kMainHeight, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 150, 20)];
    infoLabel.text = @"聊天信息免打扰";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:infoLabel];
    
    UIButton * switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 60, 7, 40, 26)];
    [switchBtn setBackgroundImage:[UIImage imageNamed:@"开关_关"] forState:UIControlStateNormal];
    [switchBtn setBackgroundImage:[UIImage imageNamed:@"开关_开"] forState:UIControlStateSelected];
    switchBtn.selected = NO;
    [switchBtn addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:switchBtn];
    [self.view addSubview:bgView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, bgView.maxY_wcr+20, kMainWidth, kMainHeight - bgView.maxY_wcr-10)];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    // 退出登录按钮
    CGFloat xPoint = AUTO_MATE_WIDTH(35);
    CGFloat yPoint = AUTO_MATE_HEIGHT(280);
    CGFloat width = kMainWidth - xPoint * 2;
    CGFloat height = AUTO_MATE_HEIGHT(35);
    UIButton *loginOutButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [loginOutButton buttonWithTitle:@"退出登录" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 2];
    [loginOutButton addTarget:self action:@selector(loginOutAction)];
    [self.view addSubview:loginOutButton];
    
}
#pragma mark - 退出登录按钮
-(void)loginOutAction {
    HLTLoginViewController *loginVC = [[HLTLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

#pragma mark - 信息免打扰按钮事件
-(void)switchBtn:(UIButton *)button
{
    if (button.selected == YES) {
        button.selected=NO;
    }else{
        button.selected = YES;
    }
}

#pragma mark - tableView  Data Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WcrSettingCell *cell = [[WcrSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.setting = _titles[indexPath.row];
    
    return cell;
    
}

#pragma mark - tableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WcrStatementViewController *statementVC = [[WcrStatementViewController alloc]init];
        [self.navigationController pushViewController:statementVC animated:YES];
        
    }else if (indexPath.row == 1) {
        WcrAboutUSViewController *statementVC = [[WcrAboutUSViewController alloc]init];
        [self.navigationController pushViewController:statementVC animated:YES];
        
    }
    
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
