//
//  RCDChatViewController.m
//  RCloudMessage
//  会话列表
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//

#import "RCDChatViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatViewController.h"
#import <RongIMLib/RongIMLib.h>


@interface RCDChatViewController ()
{
    UILabel *_titleLabel;
}
@end

@implementation RCDChatViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
    self.enableSaveNewPhotoToLocalSystem = YES;

    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    
    //返回导航键
//    float width = 14;
//    float height = width * (35.0 / 25.0);
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
//    UIImage *image = [UIImage imageFileNamed:@"返回"];
//    [button setBackgroundImage:image forState:0];
//    [button addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = leftItem;

    //标题
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake( 0, 0, kMainWidth / 1.8, 44)];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainWidth / 1.8, 44)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = self.title;
    [headView addSubview:_titleLabel];
    self.navigationItem.titleView = headView;


  //  [self notifyUpdateUnreadMessageCount];
/***********如何自定义面板功能***********************
 自定义面板功能首先要继承RCConversationViewController，如现在所在的这个文件。
 然后在viewDidLoad函数的super函数之后去编辑按钮：
 插入到指定位置的方法如下：
 [self.pluginBoardView insertItemWithImage:imagePic
                                     title:title
                                   atIndex:0
                                       tag:101];
 或添加到最后的：
 [self.pluginBoardView insertItemWithImage:imagePic
                                     title:title
                                       tag:101];
 删除指定位置的方法：
 [self.pluginBoardView removeItemAtIndex:0];
 删除指定标签的方法：
 [self.pluginBoardView removeItemWithTag:101];
 删除所有：
 [self.pluginBoardView removeAllItems];
 更换现有扩展项的图标和标题:
 [self.pluginBoardView updateItemAtIndex:0 image:newImage title:newTitle];
 或者根据tag来更换
 [self.pluginBoardView updateItemWithTag:101 image:newImage title:newTitle];
 以上所有的接口都在RCPluginBoardView.h可以查到。
 
 当编辑完扩展功能后，下一步就是要实现对扩展功能事件的处理，放开被注掉的函数
 pluginBoardView:clickedItemWithTag:
 在super之后加上自己的处理。
 
 */
    [self setNavigationBarProperty];
    
    [self addLeftBackItem];

}

-(void)addLeftBackItem
{
    
    float width = 10;
    float height = 15;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    UIImage *image = [UIImage imageNamed:@"arrow"];
    
    [button setBackgroundImage:image forState:0];
    [button setEnlargeEdgeWithTop:10 right:20 bottom:0 left:20];
    
    [button addTarget:self action:@selector(backLeftNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)backLeftNavItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftBarButtonItemPressed:(id)sender {

    [super leftBarButtonItemPressed:sender];
}

/**
 *  此处使用自定义设置，开发者可以根据需求自己实现
 *  不添加rightBarButtonItemClicked事件，则使用默认实现。
 */
- (void)rightBarButtonItemClicked:(id)sender {
    

}


- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}


/**
 *  更新左上角未读消息数
 */
//- (void)notifyUpdateUnreadMessageCount {
//  __weak typeof(&*self) __weakself = self;
//  int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
//    @(ConversationType_PRIVATE),
//    @(ConversationType_DISCUSSION),
//    @(ConversationType_APPSERVICE),
//    @(ConversationType_PUBLICSERVICE),
//    @(ConversationType_GROUP)
//  ]];
//  dispatch_async(dispatch_get_main_queue(), ^{
//      NSString *backString = nil;
//    if (count > 0 && count < 1000) {
//      backString = [NSString stringWithFormat:@"返回(%d)", count];
//    } else if (count >= 1000) {
//      backString = @"返回(...)";
//    } else {
//      backString = @"返回";
//    }
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 6, 67, 23);
//    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
//    backImg.frame = CGRectMake(-10, 0, 22, 22);
//    [backBtn addSubview:backImg];
//    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 65, 22)];
//    backText.text = backString;//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
//    backText.font = [UIFont systemFontOfSize:15];
//    [backText setBackgroundColor:[UIColor clearColor]];
//    [backText setTextColor:[UIColor whiteColor]];
//    [backBtn addSubview:backText];
//    [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    [__weakself.navigationItem setLeftBarButtonItem:leftButton];
//  });
//}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
{
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

//-(void)setTitle:(NSString *)title
//{
//    title = self.userName;
//    [super setTitle:title];
//    
//    _titleLabel.text = title;
//}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    switch (tag) {
        case 101: {
            //这里加你自己的事件处理
        } break;
        default:
            break;
    }
}

@end
