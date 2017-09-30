//
//  WcrSettingViewController.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrSettingViewController.h"
#import "WcrSettingTitle.h"
#import "WcrSettingCell.h"
#import "WcrStatementViewController.h"
#import "WcrAboutUSViewController.h"
#import "LoginViewController.h"
#import "LoginResponseAccount.h"
#import "RongYunTools.h"

#import <ShareSDK/ShareSDK.h>

@interface WcrSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation WcrSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    _titles = [WcrSettingTitle createTitles];
    
    [self addLeftBackItem];
    
    [self setNavigationBarProperty];
    
    [self customSettingUI];
    
}

-(void)customSettingUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10.0, kMainWidth, kMainHeight - 10.0)];
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
    // 清空登录信息
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    // 登录文件路径
//    NSString *doc = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *file = [doc stringByAppendingPathComponent:@"loginResponseAccount.data"];
//    // 判断登录文件是否存在
//    if ( [fileManager fileExistsAtPath:file]) {
//       [fileManager removeItemAtPath:file error:nil];
//    }
    [LoginResponseAccount remove];
    [AppConfig removeLoginType:kPatient];
    [CoreArchive removeStrForKey:kUserIdKey];
    [RongYunTools logout];
    //取消第三方登录的授权
    [ShareSDK cancelAuthorize:SSDKPlatformTypeAny];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];

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

@end
