//
//  Tools.h
//  EHealth_HM
//
//  Created by skusdk on 13-10-12.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

//客户端显示版本号
#define kSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
#define kMainFrame   [[UIScreen mainScreen] bounds]
/** 显示器屏幕的宽度 */
#define kMainWidth    [[UIScreen mainScreen] bounds].size.width
/** 显示器屏幕的高度 */
#define kMainHeight   [[UIScreen mainScreen] bounds].size.height

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    DateTypeHHmm,   //HH:mm
    DateTypeHHmmss, //HH:mm:ss
    DateTypeYYYYmmdd,
    DateTypeMMddHHmm,
    DateTypeYAll    //YYYY-MM-dd HH:mm:ss
}DateType;

@interface TimeModel : NSObject

@property (nonatomic,copy) NSString*year;
@property (nonatomic,copy) NSString*month;
@property (nonatomic,copy) NSString*day;
@property (nonatomic,copy) NSString*hours;
@property (nonatomic,copy) NSString*minutes;
@property (nonatomic,copy) NSString*seconds;

@end

/************************************************************/

@interface Tools : NSObject

#pragma mark 系统相关信息判断
/**
 *	@brief	是否iOS7系统判断
 *
 *	@return	return value description
 */
+(BOOL) IS_IOS_7;
+(BOOL) IS_IOS_8;


+(float)getMainHeight;
+(float)getMainWidth;
/**
 *	@brief	是否568h屏判断
 *
 *	@return	return value description
 */
+(BOOL) IS_iPhone_568h;


#pragma makr - 是否第一次打开app
/**
 *  是否第一次打开app
 *
 *  @return
 */
+ (BOOL)isFirstOpenApp;

#pragma mark - 拨打电话

/**
 *  拨打电话
 *
 *  @param phoneNum 电话好吗
 */
+ (void)dialPhoneNumber:(NSString *)phoneNum;

#pragma makr - 保存当前用户的账号和密码
/**
 *  保存当前用户的账号和密码
 *
 *  @param account  账号
 *  @param password 密码
 */
+ (void)saveCurUserAccount:(NSString *)account password:(NSString *)password;

/**
 *  清除密码和账号
 *
 *  @param cleanPassword 是否清除密码
 *  @param cleanAccount  清除账号
 */
+ (void)cleanPassword:(BOOL)cleanPassword account:(BOOL)cleanAccount;

/**
 *  加密字符串
 *
 *  @param string 原来字符串
 *
 *  @return 加密后的
 */
+ (NSString *)encryptionString:(NSString *)string;

#pragma mark - 取用户当前的账号
/**
 *  取用户的账号
 *
 *  @return 用户账号
 */
+ (NSString *)getCurAccount;

#pragma mark - 取用户当前的密码
/**
 *  用户当前的密码
 *
 *  @return 用户密码
 */
+ (NSString *)getCurPassword;




#pragma mark 时间格式
/**
 *	@brief	获取当前系统日期
 *
 *	@return	Year = [conponent year];
 *  @return	month = [conponent month];
 *  @return	day = [conponent day];
 */
-(NSDateComponents*)getDateNow;

#pragma mark - 获取系统当前时间
/**
 *	@brief	获取系统当前时间
 *
 *	@param 	type 	DateType
 *
 *	@return	typeStyle
 */
+(NSString*)getDateTimeNow:(DateType)type;


#pragma mark - 获取当前时间小时
/**
 *	@brief	获取当前时间小时
 *
 *	@return	当前小时数
 */
+(double)getDateHour;


#pragma mark - 获取当前分钟数
/**
 *	@brief	获取当前分钟数
 *
 *	@return	当前分钟数
 */
+(double)getDateMini;




#pragma mark 字符处理

#pragma mark - 判断字符串是否为null @“”
/**
 *	@brief	字符空值判断
 *
 *	@param 	string 	判断的字符串
 *
 *	@return	是否为NUll
 */
+(BOOL)isBlankString:(NSString *)string;


#pragma mark - 判断是否为浮点形
/**
 *@method 判断是否为浮点形
 *@param string 字符数据
 */
+(BOOL)isPureFloat:(NSString *)string;


#pragma mark - 判断是否为整形
/**
 *@method 判断是否为整形
 *@param string 字符数据
 */
+(BOOL)isPureInt:(NSString *)string;


#pragma mark - 判断是否为空字符串，如为空转为特定字符串，否则原值返回
/**
 *  判断是否为空字符串，如为空转为特定字符串，否则原值返回
 *
 *  @param string 字符串
 *
 *  @return string
 */
+ (NSString *)changNULLString:(id)string;

+ (NSString *)changNULLString:(id)string newString:(NSString *)newString;

#pragma mark - 判断是否为空字符串，如为空转为特定字符串，否则原值返回并在后面添加特定的字符串
/**
 *  判断是否为空字符串，如为空转为特定字符串，否则原值返回并在后面添加特定的字符串
 *
 *  @param string    原字符串
 *  @param appendStr 要添加的字符串
 *
 *  @return string
 */
+ (NSString *)changNULLString:(id)string addendStr:(NSString *)appendStr;

/**
 *  改变数量单位  >= 10000 已万为单位
 *
 *  @param count 数量
 *
 *  @return
 */
+ (NSString *)changeQuantityUnit:(id)count;

#pragma mark - 获取软件版本号
/**
 *  获取软件版本号
 *
 *  @return 版本号
 */
+(NSString*)getSoftVersion;




#pragma mark - 读取本地的txt格式json数据 并解析返回字典
/**
 *  读取本地的txt格式json数据 并解析返回字典
 *
 *  @param fileName json 数据  txt 格式文件名
 *
 *  @return 字典
 */
+(NSDictionary *)readFileJsonFileName:(NSString *)fileName;

#pragma mark 序列化与反序列化
/**
 *	@brief	字典序列化成字符串
 */
+(NSString *)SerializationJson:(NSDictionary *)dictionary;


#pragma mark - json反序列化方法
/**
 *	@brief	json反序列化方法
 */
+(NSDictionary*)DeserializeJson:(NSString *)json;


#pragma mark - 取得wifi名
/**
 *  取得wifi名
 *
 *  @return wifi名
 */
+ (NSString *)getWifiName;


#pragma mark - 提示语 提示框
/**
 *  提示语出现在屏幕底部
 *
 *  @param msg 提示语
 */
+ (void ) showMsg:(NSString *)msg;

/**
 *  提示语出现在屏幕顶部
 *
 *  @param msg 提示语
 */
+(void) showMsgAtTop:(NSString *)msg;

#pragma mark - 计算字体宽
/**
 *  计算字体宽度
 *
 *  @param title  字符串
 *  @param font   字体
 *  @param height 高
 *
 *  @return 宽
 */
+ (float)calculateLabelWidth:(NSString *)title font:(UIFont *)font AndHeight:(CGFloat)height;

#pragma mark - 计算字体高
/**
 *  计算字体总的高度
 *
 *  @param title 字符串
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 高度
 */
+ (float)calculateLabelHeight:(NSString *)title font:(UIFont *)font AndWidth:(CGFloat)width;

/**
 *  把时间戳 分割成model
 *
 *  @param time 时间戳
 *
 *  @return 时间model
 */
+ (TimeModel *)splitTimeWithString:(NSString *)time;



#pragma mark -将时间字符串nsstring转为date
/**
 *  将时间字符串转为date
 *
 *  @param dateString 时间字符串
 *
 *  @return date
 */
+ (NSDate *)dateFromString:(NSString *)dateString;


#pragma mark - 将时间date转为字符串nsstring
/**
 *  将时间转为字符串
 *
 *  @param date date
 *
 *  @return 时间字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date;

#pragma 计算过去的时间和现在时间的差距
/**
 *  计算过去的时间和现在时间的差距
 *
 *  @param agoTime 过去的时间
 *
 *  @return 和现在时间差得字符串
 */
+(NSString *)changAgoTimeDate:(NSString *)agoTime;

#pragma mark - 计算将来的时间和现在时间的差距
/**
 *  计算将来的时间和现在时间的差距
 *
 *  @param futureTime 将来的时间
 *
 *  @return 将来和现在时间的距离
 */
+(NSString *)changeFutureTimeDate:(NSString *)futureTime;


#pragma mark 导航设置 获取导航堆栈内对应的UIViewController对象
/**
 *	@brief	获取导航堆栈内对应的UIViewController对象
 *
 *	@param 	navControllers 	导航堆栈
 *	@param 	outController 	需要获取的UIViewController
 *
 */
+ (UIViewController *)FindSpecificViewController:(NSArray *)navControllers outViewController:(Class)outViewController;

#pragma mark - 打开网络状态监控
+ (void)OpenNetworkMonitoring;

#pragma mark - 获取网络状态
/**
 *  获取网络是否正常
 *
 *  @return yes 正常 no 没网络
 */
+ (BOOL)getNetworkStatus;

#pragma mark - 获取缓存大小
/**
 *  获取缓存大小
 *
 *  @param completion
 */
+ (void)requestCachesFileSize:(void (^)(NSString *size))completion;


#pragma mark -清理缓存
/**
 *  清除字符串
 *
 *  @param completion
 */
+(void)clearCache:(void (^)(BOOL flag))completion;

/**
 *  将html 转为适合屏幕
 *
 *  @param html 字符串
 *
 *  @return 新的字符串
 */
+ (NSString *) getStringWithViewport:(NSString *) html;
#pragma mark CGRect位置大小
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param font 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result CGFloat 返回的高度
 */
+(CGFloat) heightForString:(NSString *) value font:(UIFont *) font andWidth:(CGFloat) width;
//+ (NSString *) getStringWithViewport:(NSString *) html;
/**
 @method 获取字符串的宽度
 @param value 待计算的字符串
 @param font 字体的大小
 @result CGFloat 返回的高度
 */
+(CGFloat) widthForString:(NSString *) value font:(UIFont *) font;
@end
