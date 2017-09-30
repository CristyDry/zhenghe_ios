//
//  ModeTextView.h
//  EHealth_HM
//
//  Created by dengwz on 13-11-4.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

// 警示信息提示框
#import <UIKit/UIKit.h>

@interface ModeTextView : UIView
{
    UILabel *lab;
    NSTimer *timer;
}

-(void)ShowMessage:(NSString *)msg;

-(void)ShowMessageAtTop:(NSString *)msg;

@end
