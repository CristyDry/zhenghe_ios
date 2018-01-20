//
//  BZDoctorListController.h
//  ZHHealth
//
//  Created by pbz on 15/12/28.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaseViewControler.h>

@protocol BZDoctorListControllerDelegate<NSObject>
@optional
- (void)pushBZProductDetailVCWithDoctorID:(NSString *) doctorID;

@end

@interface BZDoctorListController : BaseViewControler
@property (nonatomic)  BOOL isAddToShoppingcart;
@property (nonatomic,weak)  id<BZDoctorListControllerDelegate> delegate;

@end
