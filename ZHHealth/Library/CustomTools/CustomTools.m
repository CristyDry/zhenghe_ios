//
//  CustomTools.m
//  BDBox
//
//  Created by U1KJ on 15/10/30.
//  Copyright (c) 2015年 U1KJ. All rights reserved.
//

#import "CustomTools.h"

@implementation CustomTools

//将传入的NSData类型转换成NSString并返回
+ (NSString*)hexadecimalString:(NSData *)data{
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}


//将传入的NSString类型转换成NSData并返回
+ (NSData*)dataWithHexstring:(NSString *)hexstring{
    
    NSMutableData *data = [NSMutableData data];
    int idx;
    for(idx = 0; idx + 2 <= hexstring.length; idx += 2){
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexstring substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    return data;
}


//普通字符串(ASII)转换为十六进制的。
+ (NSString*)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


// 计算校验和
+(NSString*)getSumByHex:(NSString*)hex {
    
    unsigned long sum = 0;
    
    NSRange range = {0,2};
    NSString *aSub = [hex substringWithRange:range];
    
    for (int i = 0; i < [hex length] / 2 - 1; i++) {
        
        NSRange range1 = {2 * (i + 1),2};
        NSString *bSub = [hex substringWithRange:range1];
        
        sum = strtoul([aSub UTF8String],0,16) ^ strtoul([bSub UTF8String],0,16);
        //        NSLog(@"i = %d\naSub --> %@\naSub --> %@\nsum -->  %@",i,[self getBinaryByhex:aSub],[self getBinaryByhex:bSub],[self getBinaryByhex:[NSString stringWithFormat:@"%lx",sum]]);
        
        aSub = [NSString stringWithFormat:@"%lx",sum];
    }
    
    return [NSString stringWithFormat:@"%lx",sum];
}


// 盒子ID转为16进制
+(NSString*)hexStringFromBoxID:(NSString*)boxID {
    
    NSString *str = boxID;
    NSUInteger len = [str length];
    NSString *hexStrOfID = @"";
    for(NSUInteger i=0; i<len; i++){
        NSString *tempStr = hexStrOfID;
        unichar ch = [str characterAtIndex:i];
        if (ch >=48 && ch <= 57 ) {
            int i = ch;
            hexStrOfID = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%x",i - 48]];
        }else {
            hexStrOfID = [self hexStringFromString:[NSString stringWithFormat:@"%c",ch]];
        }
        hexStrOfID = [NSString stringWithFormat:@"%@%@",tempStr,hexStrOfID];
    }
    return hexStrOfID;
}


//二进制转十进制(十六进制)
+ (NSString*)toDecimalSystemWithBinarySystem:(NSString *)binary{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    //NSString * result = [NSString stringWithFormat:@"%d",ll];// 十进制
    NSString * result = [NSString stringWithFormat:@"%x",ll];// 十六进制
    
    return result;
}


//将汉字字符串转换成16进制字符串
+ (NSString*)chineseToHex:(NSString*)chineseStr{
    NSStringEncoding encodingGB18030= CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *responseData =[chineseStr dataUsingEncoding:encodingGB18030 ];
    NSString *string=[self NSDataToByteTohex:responseData];
    return string;
}
+ (NSString*)NSDataToByteTohex:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    //    NSLog(@"hexStr:%@",hexStr);
    return hexStr;
}



//将16进制字符串转换成汉字字符串
+(NSString*)changeLanguage:(NSString*)chinese{
    NSString *strResult;
    NSLog(@"chinese:%@",chinese);
    if (chinese.length%2==0) {
        //第二次转换
        NSData *newData = [self hexToByteToNSData:chinese];
        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        strResult = [[NSString alloc] initWithData:newData encoding:encode];
        NSLog(@"strResult:%@",strResult);
    }else{
        NSString *strResult = @"已假定是汉字的转换，所传字符串的长度必须是4的倍数!";
        NSLog(@"%@",strResult);
        return NULL;
    }
    return strResult;
}
+(NSData *)hexToByteToNSData:(NSString *)str{
    int j=0;
    Byte bytes[[str length]/2];
    for(int i=0;i<[str length];i++)
    {
        int int_ch;  ///两位16进制数转化后的10进制数
        unichar hex_char1 = [str characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [str characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:[str length]/2 ];
    
    return newData;
}



//将yyyy-MM-dd HH:mm:ss:SS格式时间转换成时间戳
+(long long)changeTimeToTimeSp:(NSString *)timeStr{
    long long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss:SS"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long long)([fromdate timeIntervalSince1970] * 1000);
    return time;
}


// 获取当前时间(返回十六进制的字符串)
+(NSString*)getSendTime {
    
    NSDate *fromdate=[NSDate date];
    long long  a =(long long)([fromdate timeIntervalSince1970] * 1000);
    [kUserDefaults setObject:[NSString stringWithFormat:@"%lld",a] forKey:@"time"];
    
    // 转换为十六进制的字符串
    NSString *timeOfHexStr = [NSString stringWithFormat:@"%llx",a];
    
    if (timeOfHexStr.length < 12) {
        timeOfHexStr = [NSString stringWithFormat:@"000000000000%@",timeOfHexStr];
        timeOfHexStr = [timeOfHexStr substringFromIndex:timeOfHexStr.length - 12];
    }
    return timeOfHexStr;
}


// 计算字符的字节数，并限制最大的字节数
+(int)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string andMaxLength:(int)maxLength {
    
    // 字节数
    int byteCount = 0;
    int next = 0;
    NSString *subStr ;
    for (int i = 0; i < string.length; i++) {
        if (byteCount == (maxLength - 1)) {
            next = byteCount;
        }
        
        subStr = [string substringWithRange:NSMakeRange(i, 1)];
        subStr = [CustomTools chineseToHex:subStr];
        if (subStr.length == 2) {
            byteCount += 1;
        }else {
            byteCount += 2;
        }
        
        if (byteCount == maxLength) {
            return maxLength + (i + 1);
        }else if(next == (maxLength - 1) && byteCount == (maxLength + 1)) {
            // 取到37
            return maxLength + i;
        }
    }
    
    return byteCount;
}

@end
