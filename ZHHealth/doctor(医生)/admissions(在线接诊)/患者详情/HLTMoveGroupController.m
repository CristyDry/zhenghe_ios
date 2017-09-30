//
//  HLTMoveGroupController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/26.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTMoveGroupController.h"
#import "HLTGroup.h"

@interface HLTMoveGroupController ()  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *niceButton;

@end

@implementation HLTMoveGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"移动分组";
    self.view.backgroundColor = kBackgroundColor;
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self getRequestData];
    [self addTableivew];
}

-(void)getRequestData
{
    //将所需的参数id解档出来
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = account.Id;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/manageGroup" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            weakSelf.dataArray = [HLTGroup mj_objectArrayWithKeyValuesArray:responseMd.response];
            [_tableview reloadData];
        }
    }];
}

-(void)addTableivew
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight+30, kMainWidth, kMainHeight-KTopLayoutGuideHeight-30) style:UITableViewStylePlain];
    _tableview.rowHeight = 40;
    _tableview.backgroundColor = kBackgroundColor;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableview];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"move"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"move"];
    }
    
    HLTGroup * group = _dataArray[indexPath.row];
    group.selected = NO;
    
    CGFloat width = 20;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, kMainWidth-width*3, width)];
    label.text = group.groupName;
    [cell.contentView addSubview:label];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth-width*2, 10, width, width)];
    button.selected = group.selected;
    button.tag = indexPath.row;
    [cell.contentView addSubview:button];
    
    if ([label.text isEqualToString:_huanzheModel.groupName]) {
        group.selected = YES;
        button.selected = group.selected;
        [button setImage:[UIImage imageNamed:@"iconfont-gou-2"] forState:UIControlStateSelected];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    HLTGroup * group = _dataArray[indexPath.row];
    if (![group.groupName isEqualToString:_huanzheModel.groupName]) {
        UIButton * button = (UIButton *)[_tableview viewWithTag:indexPath.row];
        [button setImage:[UIImage imageNamed:@"iconfont-gou-2"] forState:UIControlStateSelected];
        group.selected = !group.selected;
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        args[@"oldGroupId"] = _huanzheModel.groupId;
        args[@"patientId"] = _huanzheModel.ID;
        args[@"newGroupId"] = group.ID;
        [httpUtil doPostRequest:@"api/ZhengheDoctor/moveGroup" args:args targetVC:self response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self isStatus:@"移动成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
                self.tabBarController.selectedIndex = 1;
            }
        }];
    }
}

-(void)isStatus:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
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
