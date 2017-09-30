//
//  MMSChatViewController.m
//  Express_IOS
//
//  Created by ZhouZhenFu on 15/11/23.
//  Copyright © 2015年 LuCanAn. All rights reserved.
//

#import "MMSChatViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDChatViewController.h"
#import "UIImageView+WebCache.h"


@interface MMSChatViewController ()

@property (nonatomic,strong) RCConversationModel *tempModel;
@property (nonatomic,strong) UILabel *titleView;
@property (nonatomic, strong) UIView *jyTitleView;

- (void) updateBadgeValueForTabBarItem;

@end

@implementation MMSChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isShowNetworkIndicatorView = NO;
//   ; self.showConnectingStatusOnNavigatorBar = YES;
    
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
    
    //聚合会话类型
    [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
    //设置tableView样式
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    self.conversationListTableView.tableFooterView = [UIView new];
    //    self.conversationListTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 12)];
    
    // 隐藏导航栏
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self notifyUpdateUnreadMessageCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //showConnectingStatusOnNavigatorBar设置为YES时，需要重写setNavigationItemTitleView函数来显示已连接时的标题。
    self.showConnectingStatusOnNavigatorBar = YES;
    [super updateConnectionStatusOnNavigatorBar];
   
}
//由于demo使用了tabbarcontroller，当切换到其它tab时，不能更改tabbarcontroller的标题。
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.showConnectingStatusOnNavigatorBar = NO;
}

- (void)setNavigationItemTitleView {
    
    NSString * starttime = @"00:00:00";
    RCIMClient * client = [RCIMClient sharedRCIMClient];
    [client getNotificationQuietHours:^(NSString *startTime, int spansMin) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([starttime isEqualToString:startTime]) {
                _jyTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
                label.textColor = [UIColor whiteColor];
                label.text = @"在线接诊";
                label.font = [UIFont systemFontOfSize:22];
                [_jyTitleView addSubview:label];
                UIImageView * iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, 20, 20)];
                iconImage.image = [UIImage imageNamed:@"iconfont-jingyin-2"];
                [_jyTitleView addSubview:iconImage];
                self.navigationItem.titleView = _jyTitleView;
                
            }else{
                UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
                titleView.backgroundColor = [UIColor clearColor];
                titleView.font = [UIFont boldSystemFontOfSize:22];
                titleView.textColor = [UIColor whiteColor];
                titleView.textAlignment = NSTextAlignmentCenter;
                titleView.text =@"在线接诊";
                _titleView = titleView;
                self.navigationItem.titleView = titleView;
            }
        });
    } error:^(RCErrorCode status) {
        NSLog(@"查询消息状态出错");
        
    }];
}

- (void)updateBadgeValueForTabBarItem
{
    __weak typeof(self) __weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];
        
        if (count>0) {
            
//            [__weakSelf.rootTabbar setHidden:NO atIndex:2];
            //            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        }else
        {
//            [__weakSelf.rootTabbar setHidden:YES atIndex:2];
            //   __weakSelf.tabBarItem.badgeValue = nil;
        }
        
    });
}

/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:_conversationVC];
        [self presentViewController:navi animated:YES completion:nil];

//        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
    //聚合会话类型，此处自定设置。
//    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
//        
//        
//        RCDChatListViewController *temp = [[RCDChatListViewController alloc] init];
//        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
//        temp.hidesBottomBarWhenPushed = YES;
//        temp.isGroupList = YES;
//        temp.title = @"群聊列表";
//        [temp setDisplayConversationTypes:array];
//        [temp setCollectionConversationType:nil];
//        temp.isEnteredToCollectionViewController = YES;
//        [self.navigationController pushViewController:temp animated:YES];    }
    
}

//*********************插入自定义Cell*********************//

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]])
        {
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    
    return dataSource;
}

//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0f;
}

//*********************插入自定义Cell*********************//


#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    __weak typeof(&*self) blockSelf_ = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //调用父类刷新未读消息数
        [super didReceiveMessageNotification:notification];
        [blockSelf_ resetConversationListBackgroundViewIfNeeded];
        //            [self notifyUpdateUnreadMessageCount]; super会调用notifyUpdateUnreadMessageCount
        
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_DISCUSSION),
                                                                             @(ConversationType_PUBLICSERVICE),
                                                                             @(ConversationType_PUBLICSERVICE),
                                                                             @(ConversationType_GROUP)
                                                                             ]];
        if (unreadMsgCount > 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveNewsInfo" object:nil userInfo:nil];
            
        }else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoHaveNewsInfo" object:nil userInfo:nil];
            
        }
        
    });
}
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    _titleView.text = title;
}

- (void)notifyUpdateUnreadMessageCount
{
    [self updateBadgeValueForTabBarItem];
}
//重写展示空列表的方法，展示自定义的view
//- (void)showEmptyConversationView
//{
//    UIView *blankView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    blankView.backgroundColor=[UIColor redColor];
//    UITapGestureRecognizer *pictureTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
//    pictureTap.numberOfTapsRequired = 1;
//    pictureTap.numberOfTouchesRequired = 1;
//    [blankView addGestureRecognizer:pictureTap];
//    self.emptyConversationView=blankView;
//    [self.view addSubview:self.emptyConversationView];
//}

//- (void)tapPicture:(UIGestureRecognizer *)gestureRecognizer {
//  
//}
@end
