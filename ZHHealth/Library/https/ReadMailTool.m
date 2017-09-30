//
//  ReadMailTool.m
//  Model
//
//  Created by ZhouZhenFu on 15/4/30.
//  Copyright (c) 2015年 优一. All rights reserved.
//

#import "ReadMailTool.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HUD.h"

@implementation Mail_Model



@end

/*********************ReadMailTool*******************/


@implementation ReadMailTool

static ReadMailTool * mailTool = nil;

-(id)init
{
    self = [super init];
    
    if (self) {
        
        _allPersonArray = [[NSMutableArray alloc]init];
    }
    
    return self;
}

+(id)DefauleReadMailTool
{
    if (mailTool == nil) {
        
        mailTool = [[ReadMailTool alloc]init];
    }
    
    [mailTool loadMail];
    
    return mailTool;
}

-(void)loadMail{
   

    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
//    if (addressBook == nil) {
//        
//        [HUD showAlertMsg:@"获取读取通讯录权限失败！"];
//        
//        return;
//    }
    
    if(ABAddressBookGetAuthorizationStatus() == 1 || ABAddressBookGetAuthorizationStatus() == 2)//判断通讯隐私目前状态，1和2表示禁止访问，进行提示
    {
        [HUD showAlertMsg:@"你已经禁止访问通讯录，请在设置中打开"];
        
        return;
    }

    
    [self.allPersonArray removeAllObjects];
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        Mail_Model *model = [[Mail_Model alloc]init];
        
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
      
        //名字
        NSString *firstName, *lastName, *middleName,*fullName;
        NSString * sysFirstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(nil != sysFirstName){
            firstName = sysFirstName;
        }else{
            firstName = @"" ;
        }
        
        NSString * sysMiddleName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        if (nil != sysMiddleName) {
            middleName = sysMiddleName;
        }else {
            middleName = @"" ;
        }
        NSString * sysLastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if(nil != sysLastName){
            lastName = sysLastName;
        }else{
            lastName = @"";
        }
        fullName = [NSString stringWithFormat:@"%@%@%@",lastName,middleName,firstName];
        
        
        model.name = fullName;
        
        ABMultiValueRef phone =  (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        
        
        if ((phone != nil) && ABMultiValueGetCount(phone)>0) {
            
            for (int m = 0; m < ABMultiValueGetCount(phone); m++) {
                
                NSString * aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, m);
                aPhone = [aPhone stringByReplacingOccurrencesOfString :@" " withString:@""];
                aPhone = [aPhone stringByReplacingOccurrencesOfString :@"(" withString:@""];
                aPhone = [aPhone stringByReplacingOccurrencesOfString :@")" withString:@""];
                aPhone = [aPhone stringByReplacingOccurrencesOfString :@"-" withString:@""];
                
                NSString * aLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phone, m);
                
                if ([aLabel isEqualToString:@"_$!<Mobile>!$_"]) {
                    
                    model.tel = aPhone;
                    
                    break;
                }
                
            }
        }
        
        if (!([fullName length] == 0)) {
            [nameArray addObject:fullName];
        }
        
        if (![model.tel length] == 0) {
            [self.allPersonArray addObject:model];
        }
        
    }
}

@end
