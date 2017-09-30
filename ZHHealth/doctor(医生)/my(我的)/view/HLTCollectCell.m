//
//  HLTCollectCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTCollectCell.h"

@implementation HLTCollectCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}


-(void)createCell
{
    CGFloat xPoint = 20.0;
    CGFloat yPoing = 10.0;
    CGFloat width = 60.0;
    CGFloat height = 50.0;
    
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(kMainWidth-width-xPoint, yPoing, width, height)];
    [self.contentView addSubview:_imageview];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoing, kMainWidth - width -height, height)];
    _titleLabel.numberOfLines = 3;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_titleLabel];
}

-(void)setCollectModel:(HLTCollectModel *)collectModel
{
    _titleLabel.text = collectModel.title;
    [_imageview sd_setImageWithURL:[NSURL URLWithString:collectModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
