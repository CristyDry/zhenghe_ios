//
//  CustomTools.h
//  BDBox
//
//  Created by U1KJ on 15/10/30.
//  Copyright (c) 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTools : NSObject

//将传入的NSData类型转换成NSString并返回
+ (NSString*)hexadecimalString:(NSData *)data;

//将传入的NSString类型转换成NSData并返回
+ (NSData*)dataWithHexstring:(NSString *)hexstring;

//普通字符串(ASII)转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string;

// 计算校验和
+(NSString*)getSumByHex:(NSString*)hex;

// 盒子ID转为16进制
+(NSString*)hexStringFromBoxID:(NSString*)boxID;

//二进制转十进制(十六进制)
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;

//将汉字字符串转换成16进制字符串
+(NSString *)chineseToHex:(NSString*)chineseStr;

//将16进制字符串转换成汉字字符串
+(NSString*)changeLanguage:(NSString*)chinese;

//将yyyy-MM-dd HH:mm:ss:SS格式时间转换成时间戳
+(long long)changeTimeToTimeSp:(NSString *)timeStr;

// 获取当前时间(返回十六进制的字符串)
+(NSString*)getSendTime;

// 计算字符的字节数，并限制最大的字节数
+(int)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string andMaxLength:(int)maxLength;

@end
