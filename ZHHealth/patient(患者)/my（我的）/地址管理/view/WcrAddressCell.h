//
//  WcrAddressCell.h
//  ZHMedical
//
//  Created by U1KJ on 15/11/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#define kWcrAddressCellHeight 80.0f

#import <UIKit/UIKit.h>
#import "BZAddressModel.h"

@protocol  WcrAddressCellDelegate<NSObject>

- (void)pushToEditAdress:(BZAddressModel *)addressModel;

@end

@interface WcrAddressCell : UITableViewCell

@property (nonatomic, strong) BZAddressModel *addressModel;
@property (nonatomic,weak)  id<WcrAddressCellDelegate>delegate;
@end
