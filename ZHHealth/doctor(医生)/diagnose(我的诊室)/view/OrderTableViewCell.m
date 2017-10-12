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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.chuFangOptionBtn.layer.borderColor = UIColorFromHex(0xd7d7d7).CGColor;
    self.chuFangOptionBtn.layer.borderWidth = 1.0f;
    self.chuFangOptionBtn.layer.cornerRadius = 5.0f;
}

- (IBAction)ClickOpertionChufangAction:(UIButton*)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
