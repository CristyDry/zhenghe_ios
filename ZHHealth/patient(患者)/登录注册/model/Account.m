//
//  Account.m
//  ZHHealth
//
//  Created by pbz on 15/11/23.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "Account.h"

@implementation Account

+(Account *)getAccountwithJSON:(id)response {
    
    if ([response isKindOfClass:[NSDictionary class]]) {
        Account *account = [Account objectWithKeyValues:response];
        return account;
    }

    return nil;
}

@end
