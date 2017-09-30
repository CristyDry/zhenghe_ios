//
//  RCDChatViewController.h
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RCDChatViewController : RCConversationViewController

/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;

//
//RCDChatViewController *conversationVC = [[RCDChatViewController alloc]init];
//conversationVC.conversationType =  ConversationType_PRIVATE;
//conversationVC.targetId = [NSString stringWithFormat:@"%@",friendInfo.player_id];
//conversationVC.userName = [AppConfig getPlayerName:friendInfo];
//conversationVC.title =  [AppConfig getPlayerName:friendInfo];
//conversationVC.noPush = YES;
//UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:conversationVC];
//
//[self presentViewController:nvc animated:YES completion:nil];
//

@end
