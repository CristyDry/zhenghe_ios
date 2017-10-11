//
//  OrderTableViewCell.m
//  DDShop
//
//  Created by soso on 15/10/11.
//  Copyright (c) 2015年 k6161061. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:nil options:nil] firstObject];
    if (self == nil) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    return self;
}
- (IBAction)oneoneone:(id)sender {

    if (_btnBlock) {
        _btnBlock(sender);
    }
}
- (IBAction)twotwotwo:(id)sender {
    if (_btnBlock) {
        _btnBlock(sender);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
