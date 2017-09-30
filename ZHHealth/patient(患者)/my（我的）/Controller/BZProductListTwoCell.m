//
//  BZProductListTwoCell.m
//  ZHHealth
//
//  Created by pbz on 16/1/6.
//  Copyright © 2016年 U1KJ. All rights reserved.
//

#import "BZProductListTwoCell.h"
@interface BZProductListTwoCell ()

@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic,strong)  UILabel *countLabel;

@end
@implementation BZProductListTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat marginX = 10;
        CGFloat marginY = 10;
        // 产品图片
        _pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(marginX, marginY, kMainWidth * 0.22 - marginY * 2, kMainWidth * 0.22 - marginY * 2)];
        _pictureView.contentMode = UIViewContentModeScaleToFill;
        _pictureView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_pictureView];
        
        float publicX = CGRectGetMaxX(_pictureView.frame) + 15;
        // 产品名称
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(publicX, _pictureView.frame.origin.y, kMainWidth - publicX -60, _pictureView.bounds.size.height * 0.33)];
        _titleLabel.font = [UIFont systemFontOfSize:KFont - 4];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kBlackColor;
        [self.contentView addSubview:_titleLabel];
        
        // 产品规格
        _standardLabel = [[UILabel alloc]initWithFrame:CGRectMake(publicX, CGRectGetMaxY(_titleLabel.frame), _titleLabel.bounds.size.width, _titleLabel.bounds.size.height)];
        _standardLabel.font = [UIFont systemFontOfSize:KFont - 6];
        _standardLabel.backgroundColor = [UIColor clearColor];
        _standardLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_standardLabel];
        
        // 产品价格
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(publicX, CGRectGetMaxY(_standardLabel.frame), _titleLabel.bounds.size.width, _titleLabel.bounds.size.height)];
        _priceLabel.font = [UIFont systemFontOfSize:KFont - 6];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_priceLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 件数
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 60, 0, 40, kMainWidth * 0.22)];
        countLabel.textAlignment = 2;
        countLabel.textColor = [UIColor grayColor];
        _countLabel = countLabel;
        [self.contentView addSubview:countLabel];
    }
    return self;
}
- (void)setADpic:(NSString *)ADpic{
    _ADpic = ADpic;
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:ADpic]];
}
- (void)setProductDetailInfosModel:(BZProductDetailInfosModel *)productDetailInfosModel{
    _titleLabel.text = productDetailInfosModel.productName;
    _standardLabel.text = productDetailInfosModel.standard;
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", productDetailInfosModel.price];
    _countLabel.text = [NSString stringWithFormat:@"× 1"];

}


@end
