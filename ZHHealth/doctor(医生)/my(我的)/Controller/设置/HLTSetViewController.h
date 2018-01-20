//
//  HLTSetViewController.h
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaseViewControler.h>

@protocol HLTSetViewControllerDelegate <NSObject>

-(void)sentMessageStatus:(BOOL)status;

@end

@interface HLTSetViewController : BaseViewControler

@property (nonatomic, strong) id<HLTSetViewControllerDelegate> delegate;

@end
