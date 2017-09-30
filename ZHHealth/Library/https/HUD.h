//
//  HUD.h
//  EHealth_HM
//  加载框及提示框设置
//
//  Created by dengwz on 13-9-13.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUD : NSObject<MBProgressHUDDelegate>

/**
 *	@brief	无文字loading,不遮挡导航条
 *
 *	@return	HUD
 */
+(MBProgressHUD *)showUIBlockingIndicator:(UIView *)tagView;

/**
 *	@brief	带文字loading，默认为数据加载中,不遮挡导航条
 *
 *	@param 	str 	显示广西
 *
 *	@return	HUD
 */
+(MBProgressHUD *)showUIBlockingIndicator:(UIView *)tagView msg:(NSString *)msg;


/**
 *	@brief	带文字loading，可设置隐藏消失动画时间
 *
 *	@param 	str 	msg
 *	@param 	progress 	时间控制
 *
 *	@return	HUD
 */
+(MBProgressHUD *)showUIBlockingProgressIndicatorWithText:(NSString *)str andProgress:(float)progress;


/**
 *	@brief	操作提示,带标题，手动点击消失
 *
 *	@param 	titleText 	标题
 *	@param 	text 	msg
 *
 *	@return	HUD
 */
+(MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text;


/**
 *	@brief	操作提示，自设置操作方法
 *
 *	@param 	titleText 	标题
 *	@param 	text 	msg
 *	@param 	tag 	tag
 *	@param 	sel 	sel
 *
 *	@return	HUD
 */
+(MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text target:(id)tag action:(SEL)sel;


/**
 *	@brief	操作普通提示，自动消失
 *
 *	@param 	msg 	显示文字
 */
+(void)showAlertMsg:(NSString *)msg;



/**
 *	@brief	隐藏loading方法
 */
+(void)hideUIBlockingIndicator;


@end
