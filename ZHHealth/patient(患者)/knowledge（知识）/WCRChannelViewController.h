//
//  WCRChannelViewController.h
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaseViewControler.h>

@protocol WCRChannelViewControllerDelegate <NSObject>
/**
 *  定义协议方法，跳转到知识页面
 *  参数，看实际情况网络请求需要修改
 */
- (void)pushKnowledgeViewController:(NSMutableArray *)selectedButtons;
@end

@interface WCRChannelViewController : BaseViewControler
@property (nonatomic,strong)  NSMutableArray *headerButtons;
@property (nonatomic,strong)  NSArray *channelListModelA;
@property (nonatomic,weak)  id<WCRChannelViewControllerDelegate> delegate;

@end
