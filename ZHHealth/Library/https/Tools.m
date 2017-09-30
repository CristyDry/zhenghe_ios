//
//  Tools.m
//  EHealth_HM
//
//  Created by skusdk on 13-10-12.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

#import "Tools.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation TimeModel

@end

/************************************************************/

@implementation Tools
static NSDateFormatter *g_dayDateFormatter = nil;
+(BOOL)IS_IOS_7
{
    return kSystemVersion > 6.2;
}

+(BOOL)IS_IOS_8
{
    
    return kSystemVersion > 7.9;
}

+(float)getMainHeight{
    if ([Tools IS_IOS_8]){
        return kMainHeight;
    
    }else{
        return kMainWidth;
    }

}
+(float)getMainWidth{
    if ([Tools IS_IOS_8]){
        return kMainWidth;
        
    }else{
        return kMainHeight;
    }

}

+(BOOL)IS_iPhone_568h
{
    return kMainHeight > 480;
}

#pragma makr - 是否第一次打开app
+(BOOL)isFirstOpenApp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL frist = [[defaults objectForKey:@"frist"] boolValue];
    
    if (frist) {
        
        return NO;
    }
    else
    {
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"frist"];
        [defaults synchronize];
        
        return YES;
    }
}

#pragma mark - 拨打电话
+ (void)dialPhoneNumber:(NSString *)phoneNum
{
    if (!(phoneNum.length == 11) || ![RegExpValidate validatePhoneNumber:phoneNum]) {
        
        [Tools showMsg:@"号码不正确！"];
        
        return;
    }
    
    UIWebView *phoneCallWebView = nil;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma makr - 保存当前用户的账号和密码
+ (void)saveCurUserAccount:(NSString *)account password:(NSString *)password
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [userDef setObject:account forKey:@"account"];
    [userDef setObject:password forKey:@"password"];
    
    [userDef synchronize];
}

+ (void)cleanPassword:(BOOL)cleanPassword account:(BOOL)cleanAccount
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (cleanPassword) {
        
        [userDef setObject:nil forKey:@"password"];
    }
    if (cleanAccount) {
        
        [userDef setObject:nil forKey:@"account"];
    }
    [userDef synchronize];
}
+ (NSString *)encryptionString:(NSString *)string
{
    return [iOSMD5 md5:string];
}

#pragma mark - 用户当前的账号
+ (NSString *)getCurAccount
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *account = [userDef objectForKey:@"account"];
    
    if (account) {
        
        return account;
    }
    else
    {
        return @"";
    }
}
#pragma mark - 用户当前的密码
+ (NSString *)getCurPassword
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSString *password = [userDef objectForKey:@"password"];
    
    if (password) {
        return password;
    }
    else
    {
        return @"";
    }
    
}


-(NSDateComponents*)getDateNow
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *conponent = [cal components:unitFlags fromDate:[NSDate date]];
    return conponent;
}

#pragma mark - 获取系统当前时间
+(NSString*)getDateTimeNow:(DateType)type
{
    NSDate *date = [NSDate date];
    
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }
    
    NSDateFormatter *dateFormatter = g_dayDateFormatter;
    switch (type) {
        case DateTypeHHmm:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case DateTypeHHmmss:
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            break;
        case DateTypeYAll:
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            break;
        case DateTypeYYYYmmdd:
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            break;
        default:
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            break;
    }
    
    return [dateFormatter stringFromDate:date];
}

#pragma mark - 获取当前时间小时
+(double)getDateHour
{
    NSDate *date = [NSDate date];
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }

    NSDateFormatter *dateFormatter = g_dayDateFormatter;
    [dateFormatter setDateFormat:@"HH"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    return [strHour doubleValue];
}

#pragma mark - 获取当前分钟数
+(double)getDateMini
{
    NSDate *date = [NSDate date];
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }

    NSDateFormatter *dateFormatter = g_dayDateFormatter;
    [dateFormatter setDateFormat:@"mm"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    return [strHour doubleValue];
}

#pragma mark - 判断字符串是否为null @“”
+ (BOOL)isBlankString:(NSString *)string
{
    NSString *temp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (temp == nil) {
        return YES;
    }
    if (temp == NULL) {
        return YES;
    }
    if ([temp isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if(temp.length < 1){
        return YES;
    }
    return NO;
}


/**
 *@method 判断是否为整形
 *@param string 字符数据
 */
+(BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 判断是否为浮点形
+(BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 判断是否为空字符串，如为空转为特定字符串，否则原值返回
+ (NSString *)changNULLString:(id)string
{
    if ([Tools isBlankString:string]) {
        
        return @"暂无";
    }
    else
    {
        return string;
    }
}
+ (NSString *)changNULLString:(id)string newString:(NSString *)newString
{
    if ([Tools isBlankString:string]) {
        
        if (newString) {
            
            return newString;
        }
        return @"暂无";
    }
    else
    {
        return string;
    }

}

#pragma mark - 判断是否为空字符串，如为空转为特定字符串，否则原值返回并在后面添加特定的字符串
+ (NSString *)changNULLString:(id)string addendStr:(NSString *)appendStr
{
    if ([Tools isBlankString:string]) {
        
        return @"暂无";
    }
    else
    {
        return [NSString stringWithFormat:@"%@%@",string,appendStr];
    }
}

+ (NSString *)changeQuantityUnit:(id)count
{
    NSString *newStr = nil;
    if ([count intValue] > 9999) {
        
        float newCount = [count floatValue] / 10000.0;
        
        newStr = [NSString stringWithFormat:@" %.2f万",newCount];
    }
    else
    {
        if (!count) {
            
            newStr = @" 0";
        }
        else
        {
            newStr = [NSString stringWithFormat:@" %@",count];
            
        }
    }
    return newStr;
}


#pragma mark - 获取app版本
+(NSString*)getSoftVersion
{
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
}

#pragma mark -
#pragma mark - 读取本地的txt格式json数据 并解析返回字典
+(NSDictionary *)readFileJsonFileName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    
    NSString * jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return [Tools DeserializeJson:jsonString];
}


#pragma mark - 字典序列化成字符串
+(NSString *)SerializationJson:(NSDictionary *)dictionary
{
    if([NSJSONSerialization isValidJSONObject:dictionary]){
        NSError *error;
        NSData *dictionaryData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        CLog(@"SerialixationJson>>%@",error);
        return [[NSString alloc]initWithData:dictionaryData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark - json反序列化方法
+(NSDictionary*)DeserializeJson:(NSString *)json
{
    if(json != nil){
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]options:kNilOptions error:&error];
//        CLog(@"DeserializeJson>>%@",error);
//        CLog(@"dictionary>>%@",dictionary);
        return dictionary;
    }
    return nil;
}

#pragma mark - 取得wifi名
+ (NSString *)getWifiName{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

#pragma mark - 提示语
+ (void ) showMsg:(NSString *)msg{
    
 [[[ModeTextView alloc]init]ShowMessage:msg];

}
+(void)showMsgAtTop:(NSString *)msg
{
    [[[ModeTextView alloc]init]ShowMessageAtTop:msg];
    
}

#pragma 计算字体的宽
+(float)calculateLabelWidth:(NSString *)title font:(UIFont *)font AndHeight:(CGFloat)height
{
    float width = [title boundingRectWithSize:CGSizeMake(999, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
    return width;
}
#pragma mark - 计算字体高
+(float)calculateLabelHeight:(NSString *)title font:(UIFont *)font AndWidth:(CGFloat)width
{
    float height = [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;

    if (kMainWidth > 320) {
        
        height += 15;
    }
    
    return height;

}

+ (TimeModel *)splitTimeWithString:(NSString *)time
{
    TimeModel *model = [[TimeModel alloc]init];
    NSArray *array = [time componentsSeparatedByString:@"-"];
    NSString *year = [array objectAtIndex:0];
    NSString *month = [array objectAtIndex:1];
    
    //日和时分秒
    NSString *day = [array lastObject];
    array = [day componentsSeparatedByString:@" "];
    day = [array firstObject];
    
    //时分秒
    NSString *hours = [array lastObject];
    array = [hours componentsSeparatedByString:@":"];
    hours = [array objectAtIndex:0];
    NSString *minutes = [array objectAtIndex:1];
    NSString *seconds = [array lastObject];
    
    model.year = year;
    model.month = month;
    model.day = day;
    model.hours = hours;
    model.minutes = minutes;
    model.seconds = seconds;
    
    return model;
}

#pragma mark -将时间字符串nsstring转为date
+ (NSDate *)dateFromString:(NSString *)dateString{
    
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }

    NSDateFormatter *dateFormatter = g_dayDateFormatter;
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark - 将时间date转为字符串nsstring
+ (NSString *)stringFromDate:(NSDate *)date{
    
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc]init];
    }

    NSDateFormatter *dateFormatter = g_dayDateFormatter; //zzz表⽰示时区,zzz可以删除,这样返回的⽇日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma 计算过去的时间和现在时间的差距
+(NSString *)changAgoTimeDate:(NSString *)release_time
{
    
    if ([release_time isKindOfClass:[NSNull class]] || !release_time) {
        
        return @"未知";
    }
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc] init];
    }
     [g_dayDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeText=@"";
    
    NSDate *time = [Tools dateFromString:release_time];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSHourCalendarUnit |
                                                         NSMinuteCalendarUnit |
                                                         NSSecondCalendarUnit)
                                               fromDate:time
                                                 toDate:[NSDate date] options:0];
    
    [g_dayDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
   
    if ([components year]) {
        timeText = [[g_dayDateFormatter stringFromDate:time] substringToIndex:10];
    } else if ([components month]) {
        timeText = [[g_dayDateFormatter stringFromDate:time] substringToIndex:10];
    } else if ([components day]) {
        if ([components day] > 7) {
            timeText = [[g_dayDateFormatter stringFromDate:time] substringToIndex:10];
        } else {
            timeText = [NSString stringWithFormat:@"%d天前", (int)[components day]];
        }
    } else if ([components hour]) {
        timeText = [NSString stringWithFormat:@"%d小时前", (int)[components hour]];
    } else if ([components minute]) {
        if ([components minute] < 0) {
            timeText = @"刚刚";
        } else {
            timeText = [NSString stringWithFormat:@"%d分钟前", (int)[components minute]];
        }
    } else if ([components second]) {
        if ([components second] < 0) {
            timeText = @"刚刚";
        } else {
            timeText = [NSString stringWithFormat:@"%d秒前", (int)[components second]];
        }
    } else {
        timeText = @"刚刚";
    }
    return timeText;
    
    
}

#pragma mark - 计算将来的时间和现在时间的差距
+(NSString *)changeFutureTimeDate:(NSString *)futureTime
{
    if ([futureTime isKindOfClass:[NSNull class]] || !futureTime) {
        
        return @"未知";
    }
    
    if (!g_dayDateFormatter) {
        
        g_dayDateFormatter = [[NSDateFormatter alloc] init];
    }
    [g_dayDateFormatter  setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *date = [g_dayDateFormatter dateFromString:futureTime];
    NSTimeInterval time = [date timeIntervalSinceNow];
    
    int intTime = (int)time;
    
    if (intTime <= 0) {
        
        return @"已过期！";
    }
    
    int day = intTime / (3600 *24);
    int remain = intTime % (3600*24);//剩余多少秒
    int hour = remain / 3600;//小时
    remain = intTime % 3600;//剩余多少秒
    int miniute = remain / 60;//剩余分钟
    //int second = remain % 60;//剩余秒
    
    NSString *strTime = nil;
    
    if (day > 0) {
        
        strTime = [NSString stringWithFormat:@"%d天%d小时后",day,hour];
     }
    else
    {
        hour = intTime / 3600;
        remain = intTime % 3600;
        miniute = remain / 60;
        
        if (hour > 0) {
            
            strTime = [NSString stringWithFormat:@"%d小时 %d分钟后",hour,miniute];
        }
        else
        {
            miniute = intTime / 60;
            if (miniute > 0) {
                
                strTime = [NSString stringWithFormat:@"%d分钟后",miniute];
            }
            else
            {
                strTime = [NSString stringWithFormat:@"%d秒后",intTime];
            }
        }
        
    }
    return strTime;
    
}

+(UIViewController *)FindSpecificViewController:(NSArray *)navControllers outViewController:(Class)outViewController
{
    if(navControllers == nil) return nil;
    UIViewController *outController = nil;
   
    for(UIViewController *controoler in navControllers){
        
        if([controoler isKindOfClass:outViewController]){
            outController = controoler;
            break;
        }
    }
    return outController;
}

#pragma mark - 打开网络状态监控
+ (void)OpenNetworkMonitoring
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    // 开启网络监视器
    [afNetworkReachabilityManager startMonitoring];
//    
//    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:{
//                NSLog(@"网络不通");
//                break;
//            }
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//            {
//                NSLog(@"网络通过WIFI连接");
//                break;
//            }
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:{
//                NSLog(@"网络通过无线连接");
//                break;
//            }
//            default:
//                break;
//        }
//        
//    }];

}

#pragma mark - 获取网络状态
+ (BOOL)getNetworkStatus
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    BOOL netWorkStatu = NO;
    switch (afNetworkReachabilityManager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:{
            
            netWorkStatu = NO;
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi:
        case AFNetworkReachabilityStatusReachableViaWWAN:{
           
            netWorkStatu = YES;
            break;
        }
        default:
            break;
    }

    return netWorkStatu;
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (NSString *) getStringWithViewport:(NSString *) html{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"jsp"];
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"thelasttest" ofType:@"jsp"];
    //    NSString *_rememberWebString = [_data.recite stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString * path1_strd = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString * path2_strd = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
    NSString * strd = [NSString stringWithFormat:@"%@%@%@",path1_strd,html,path2_strd];
    return strd;
    
}

#pragma mark - 获取缓存大小
//遍历文件夹获得文件夹大小，返回多少M
+ (void)requestCachesFileSize:(void (^)(NSString *))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSString *folderPath = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"];
        NSFileManager* manager = [NSFileManager defaultManager];
        NSString *sizeStr = @"0M";
        if (![manager fileExistsAtPath:folderPath])
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(sizeStr);
            });
        }
        else
        {
            NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
            NSString* fileName;
            long long folderSize = 0;
            while ((fileName = [childFilesEnumerator nextObject]) != nil){
                NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
                folderSize += [Tools fileSizeAtPath:fileAbsolutePath];
            }
            float sizeM = folderSize/(1024.0*1024.0);
            
            if (sizeM < 1) {
                
                int size = (int)1024 * sizeM;
                
                sizeStr = [NSString stringWithFormat:@"%d k",size];
            }
            else
            {
                sizeStr = [NSString stringWithFormat:@"%0.2f M",sizeM];
            }

            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(sizeStr);
            });
        }
    });
}

#pragma mark -清理缓存
+(void)clearCache:(void (^)(BOOL))completion
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                       
                           completion(YES);
                       
                       });
                   });
}
//
//+ (NSString *) getStringWithViewport:(NSString *) html{
//    
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"jsp"];
//    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"thelasttest" ofType:@"jsp"];
//    //    NSString *_rememberWebString = [_data.recite stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//    NSString * path1_strd = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSString * path2_strd = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
//    NSString * strd = [NSString stringWithFormat:@"%@%@%@",path1_strd,html,path2_strd];
//    return strd;
//    
//}
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param font 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result CGFloat 返回的高度
 */
+(CGFloat) heightForString:(NSString *) value font:(UIFont *) font andWidth:(CGFloat) width
{
    CGSize sizeToFit = [value sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    return sizeToFit.height;
}

/**
 @method 获取字符串的宽度
 @param value 待计算的字符串
 @param font 字体的大小
 @result CGFloat 返回的高度
 */
+(CGFloat) widthForString:(NSString *) value font:(UIFont *) font
{
    CGSize sizeToFit = [value sizeWithFont:font];
    return sizeToFit.width;
}

@end
