//
//  Account.h
//  ZHHealth
//
//  Created by pbz on 15/11/23.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreArchive.h"

@interface Account : NSObject
/**
 *  channel = 1;
 createDate = "2015-11-23 16:42:40";
 creator = 18076701953;
 id = 55a1d005f1c84c0a91d5d8d9f5bcfa9b;
 isNewRecord = 0;
 password = 123;
 phone = 18076701953;
 status = 1;
 updateDate = "2015-11-23 16:42:40";
 */
@property (nonatomic,copy)  NSString *channel;
@property (nonatomic,copy)  NSString *createDate;
@property (nonatomic,copy)  NSString *creator;
@property (nonatomic,copy)  NSString *ID;
@property (nonatomic,copy)  NSString *isNewRecord;
@property (nonatomic,copy)  NSString *password;
@property (nonatomic,copy)  NSString *phone;
@property (nonatomic,copy)  NSString *status;
@property (nonatomic,copy)  NSString *updateDate;

+(Account*)getAccountwithJSON:(id)response;


@end
