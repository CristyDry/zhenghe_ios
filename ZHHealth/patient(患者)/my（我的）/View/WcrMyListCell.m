//
//  WcrMyListCell.m
//  ZHMedical
//
//  Created by U1KJ on 15/11/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WcrMyListCell.h"

@interface WcrMyListCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation WcrMyListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconIV = [[UIImageView alloc]init];
        _iconIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconIV];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kBorder + 40, 0, 200, 44)];
        _nameLabel.font = [UIFont systemFontOfSize:KFont - 4];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        CGFloat width = 10.0f;
        CGFloat height = 17.0f;
        CGFloat xPoint = kMainWidth - kBorder - width;
        CGFloat yPoint = (self.contentView.height_wcr - height) / 2.0;
        UIImageView *arrowIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        arrowIV.backgroundColor = [UIColor clearColor];
        arrowIV.image = [UIImage imageFileNamed:@"后退-拷贝" andType:YES];
        [self.contentView addSubview:arrowIV];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(kBorder, self.height_wcr - 1, kMainWidth - kBorder, 1)];
        line.backgroundColor = KLineColor;
        [self.contentView addSubview:line];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

-(void)setMyList:(WcrMyList *)myList {
    _myList = myList;
    
    _iconIV.image = [UIImage imageFileNamed:myList.imageName andType:YES];
    CGSize size = _iconIV.image.size;
    _iconIV.frame = CGRectMake(kBorder, 0, size.width, size.height);
    _iconIV.centerY_wcr = self.contentView.centerY_wcr;
    
    _nameLabel.text = myList.name;
    
}

@end
