//
//  WcrAddressCell.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrAddressCell.h"

@interface WcrAddressCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *phoneIV;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation WcrAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat xPoint = 10.0;
        CGFloat width = 25.0f;
        CGFloat height = width;
        CGFloat yPoint = (kWcrAddressCellHeight / 2.0 - height) / 2.0 + 5;
        
        _iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_iconIV imageViewWithImageName:@"" andModeScaleAspectFill:YES andCorner:height / 2.0];
        [self.contentView addSubview:_iconIV];
        
        xPoint = _iconIV.maxX_wcr + 5;
        yPoint = 5.0f;
        width = AUTO_MATE_WIDTH(120);
        height = kWcrAddressCellHeight / 2.0;
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_nameLabel labelWithText:@"" andTextColor:kBlackColor andFontSize:KFont - 5 andBackgroundColor:nil];
        [self.contentView addSubview:_nameLabel];
        
        
        height = 20.0;
        UIImage *phoneImage = [UIImage imageFileNamed:@"iconfont-phone-2" andType:YES];
        width = [phoneImage InProportionAtHeight:height];
        xPoint = _nameLabel.maxX_wcr;
        yPoint = (kWcrAddressCellHeight / 2.0 - height) / 2.0 + 5;
        
        _phoneIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_phoneIV imageViewWithImageName:@"iconfont-phone-2" andModeScaleAspectFill:YES];
        [self.contentView addSubview:_phoneIV];
        
        xPoint = _phoneIV.maxX_wcr + 5;
        yPoint = 5.0f;
        height = kWcrAddressCellHeight / 2.0;
        width = AUTO_MATE_WIDTH(110);
        
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_phoneLabel labelWithText:@"" andTextColor:kBlackColor andFontSize:KFont - 6 andBackgroundColor:nil];
        [self.contentView addSubview:_phoneLabel];
        
        xPoint = 10.0f;
        yPoint = kWcrAddressCellHeight / 2.0;
        height = kWcrAddressCellHeight / 2.0;
        width = kMainWidth - 20.0f - kBorder;
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_addressLabel labelWithText:@"" andTextColor:kGrayColor andFontSize:KFont - 6 andBackgroundColor:nil];
        _addressLabel.numberOfLines = 2;
        [self.contentView addSubview:_addressLabel];
        
        width = 50.0f;
        height = 30.0f;
        xPoint = kMainWidth - kBorder - width;
        yPoint = (kWcrAddressCellHeight - height) / 2.0;
        UIButton *arrowIV = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        arrowIV.backgroundColor = [UIColor clearColor];
        [arrowIV setImage:[UIImage imageNamed:@"后退-拷贝-2"] forState:UIControlStateNormal];
//        [arrowIV setTitle:@"编辑" forState:UIControlStateNormal];
        [arrowIV setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [arrowIV addTarget:self action:@selector(editAdress) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:arrowIV];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10.0, kWcrAddressCellHeight - 1, kMainWidth - kBorder, 1)];
        line.backgroundColor = KLineColor;
        [self.contentView addSubview:line];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}
// 点击cell右边的小箭头
- (void)editAdress{
    if ([_delegate respondsToSelector:@selector(pushToEditAdress:)]) {
        [_delegate pushToEditAdress:_addressModel];
    }

}
- (void)setAddressModel:(BZAddressModel *)addressModel{
    _addressModel = addressModel;
    _iconIV.image = [UIImage imageNamed:@"头像"];
//    _iconIV.image = [UIImage imageFileNamed:wcrAddress.icon andType:YES];
    
    _nameLabel.text = addressModel.name;
    
    _phoneLabel.text = addressModel.phone;
    
    _addressLabel.text = addressModel.address;
}
@end
