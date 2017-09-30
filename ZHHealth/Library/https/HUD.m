//
//  HUD.m
//  EHealth_HM
//  加载框及提示框设置
//
//  Created by dengwz on 13-9-13.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ModeTextView.h"
#import "HUD.h"


/**
 *	@brief	手电筒效果
 */
@interface GlowButton : UIButton<MBProgressHUDDelegate>
@end

static UIView * lastViewWithHUD = nil;
@implementation GlowButton
{
    NSTimer * timer;
    float glowDelta;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.9;
        
        glowDelta = 0.2;
        timer = [NSTimer timerWithTimeInterval:0.05f
                                        target:self
                                      selector:@selector(glow)
                                      userInfo:nil
                                       repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

-(void)glow
{
    if(self.layer.shadowRadius > 7.0 || self.layer.shadowRadius < 0.1){
        glowDelta *= -1;
    }
    self.layer.shadowRadius += glowDelta;
    
}

@end


@implementation HUD

+(UIView *)rootView
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController.view;
}

/**
 *	@brief	用于当前视图的loading，导航可遮挡，不可操作
 *
 *	@return	HUD
 */
+(MBProgressHUD *)showUIBlockingIndicator:(UIView *)tagView msg:(NSString *)msg
{
    if(msg == nil){
        msg = @"加载中...";
    }
    return [self showUIBlockingIndicatorWithText:msg tagView:tagView];
}

+(MBProgressHUD *)showUIBlockingIndicator:(UIView *)tagView
{
    return [self showUIBlockingIndicatorWithText:nil tagView:tagView];
}

+(MBProgressHUD *)showUIBlockingIndicatorWithText:(NSString *)str tagView:(UIView *)tagView
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    UIView *targetView = tagView;
    if(targetView == nil) targetView = [self rootView];
    lastViewWithHUD = targetView;
    [MBProgressHUD hideHUDForView:targetView animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.labelText = str;
    
    return hud;
}

+(MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text
{
    return [self showAlertWithTitle:titleText text:text target:nil action:nil];
}

+(MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text target:(id)tag action:(SEL)sel
{
    [HUD hideUIBlockingIndicator];
    UIView * targetView = [self rootView];
    if(targetView == nil) return nil;
    lastViewWithHUD = targetView;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.labelText = titleText;
    hud.detailsLabelText = text;
    GlowButton *btnClose = [GlowButton buttonWithType:UIButtonTypeCustom];
    if(tag != nil && sel !=nil){
        [btnClose addTarget:tag action:sel forControlEvents:UIControlEventTouchUpInside];
    }else{
        [btnClose addTarget:hud action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIImage *imgClose = [UIImage imageNamed:@"btnCheck.png"];
    [btnClose setImage:imgClose forState:UIControlStateNormal];
    [btnClose setFrame:CGRectMake(0, 0, imgClose.size.width, imgClose.size.height)];
    
    hud.customView = btnClose;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
    
}

+(MBProgressHUD *)showUIBlockingProgressIndicatorWithText:(NSString *)str andProgress:(float)progress
{
    [HUD hideUIBlockingIndicator];
    
    UIView *targetView = [self rootView];
    if(targetView==nil) return nil;
    lastViewWithHUD = targetView;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.labelText = str;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.progress = progress;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+(void)showAlertMsg:(NSString *)msg
{
    
    if([Tools IS_IOS_8]){
        ModeTextView *textView = [[ModeTextView alloc]init];
        [textView ShowMessage:msg];

        
    }else{
        UIView *targetView = [UIApplication sharedApplication].keyWindow;
        //    CLog(@"%f",targetView.frame.size.height);
        
        if(targetView==nil) return;
        lastViewWithHUD = targetView;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = msg;
        hud.margin = 8.0f;
        hud.yOffset = 165.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    
    }
   
    
}


+(void)hideUIBlockingIndicator
{
    [MBProgressHUD hideAllHUDsForView:lastViewWithHUD animated:YES];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

}


@end












