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

#import "RongYunTools.h"

@interface HLTSetViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIButton *switchBtn;

@property (nonatomic, assign) BOOL isSelected;

@end

@implementation HLTSetViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self customSettingUI];
}
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
    
    _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 60, 7, 40, 26)];
    [_switchBtn setImage:[UIImage imageNamed:@"开关_关"] forState:UIControlStateNormal];
    [_switchBtn setImage:[UIImage imageNamed:@"开关_开"] forState:UIControlStateSelected];
    [_switchBtn addTarget:self action:@selector(switchbtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_switchBtn];
    [self.view addSubview:bgView];
    
    NSString * starttime = @"00:00:00";
    RCIMClient * client = [RCIMClient sharedRCIMClient];
    [client getNotificationQuietHours:^(NSString *startTime, int spansMin) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if ([starttime isEqualToString:startTime]) {
                _isSelected = YES;
                _switchBtn.selected = YES;
                NSLog(@"查询消息屏蔽状态成功");
            }else{
                _isSelected = NO;
                _switchBtn.selected = _isSelected;
                NSLog(@"查询消息屏蔽状态有问题");
            }
        });
        
    } error:^(RCErrorCode status) {
        NSLog(@"查询消息屏蔽状态失败");
        
    }];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, bgView.maxY_wcr+20, kMainWidth, 150)];
    [self initializationTableViewWithTableView:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    // 退出登录按钮
    CGFloat xPoint = AUTO_MATE_WIDTH(35);
    CGFloat yPoint = _tableView.maxY_wcr+AUTO_MATE_HEIGHT(80);
    CGFloat width = kMainWidth - xPoint * 2;
    CGFloat height = AUTO_MATE_HEIGHT(35);
    UIButton *loginOutButton = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [loginOutButton buttonWithTitle:@"退出登录" andTitleColor:[UIColor whiteColor] andBackgroundImageName:@"圆角矩形-1-拷贝-5" andFontSize:KFont - 2];
    [loginOutButton addTarget:self action:@selector(loginOutAction)];
    [self.view addSubview:loginOutButton];
    
}
#pragma mark - 退出登录按钮
-(void)loginOutAction {
    [HLTLoginResponseAccount remove];
    [AppConfig removeLoginType:kDoctor];
    [CoreArchive removeStrForKey:kUserIdKey];
    [RongYunTools logout];
    HLTLoginViewController *loginVC = [[HLTLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

#pragma mark - 信息免打扰按钮事件
-(void)switchbtn
{
    
    if (_switchBtn.selected == YES) {
        _switchBtn.selected=NO;
        
        RCIMClient * client = [RCIMClient sharedRCIMClient];
        //删除屏蔽时间
        [client removeConversationNotificationQuietHours:^{
            NSLog(@"删除成功");
            [self.delegate sentMessageStatus:NO];
            _isSelected = NO;
        } error:^(RCErrorCode status) {
            NSLog(@"删除失败==%ld",(long)status);
        }];
        
    }else{
        
        _switchBtn.selected = YES;
        
        RCIMClient * client = [RCIMClient sharedRCIMClient];
        //屏蔽会话[NSString stringWithFormat:@"%@ s",dateString]
        [client setConversationNotificationQuietHours:@"00:00:00" spanMins:1439 success:^{
            NSLog(@"屏蔽成功");
            [self.delegate sentMessageStatus:NO];
            _isSelected = YES;
        } error:^(RCErrorCode status) {
            NSLog(@"屏蔽失败==%ld",(long)status);
        }];
        
    }
}

/*!
 屏蔽会话在某个时间段的消息提醒
 
 @param startTime       开始屏蔽消息提醒的时间，格式为HH:MM:SS s
 @param spanMins         需要屏蔽消息提醒的分钟数，0 < spanMins < 1440
 @param successBlock    屏蔽成功的回调
 @param errorBlock      屏蔽失败的回调 [status:屏蔽失败的错误码]
 
 @discussion 此方法设置的屏蔽时间会在每天该时间段时生效。
 如果您使用IMLib，此方法会屏蔽该会话在该时间段的远程推送；如果您使用IMKit，此方法会屏蔽该会话在该时间段的所有提醒（远程推送、本地通知、前台提示音）。
 */
//- (void)setConversationNotificationQuietHours:(NSString *)startTime
//                                     spanMins:(int)spanMins
//                                      success:(void (^)())successBlock
//                                        error:(void (^)(RCErrorCode status))errorBlock
//{
//    
//}




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
