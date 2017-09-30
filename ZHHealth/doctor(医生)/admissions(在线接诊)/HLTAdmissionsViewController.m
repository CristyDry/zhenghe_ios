//
//  HLTAdmissionsViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTAdmissionsViewController.h"
#import "HLTChatViewController.h"
#import "HLTSetViewController.h"

@interface HLTAdmissionsViewController ()
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) UIView * titleView;


@end

@implementation HLTAdmissionsViewController
                         

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![HLTLoginResponseAccount isLogin]) {
        HLTLoginViewController * login = [[HLTLoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}

/*!
 查询会话消息提醒的屏蔽时间段设置
 
 @param successBlock    屏蔽成功的回调 [startTime:已设置的屏蔽开始时间, spansMin:已设置的屏蔽时间分钟数，0 < spansMin < 1440]
 @param errorBlock      查询失败的回调 [status:查询失败的错误码]
 */
//- (void)getNotificationQuietHours:(void (^)(NSString *startTime, int spansMin))successBlock
//                            error:(void (^)(RCErrorCode status))errorBlock;

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
