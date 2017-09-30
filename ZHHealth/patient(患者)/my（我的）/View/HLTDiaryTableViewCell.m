//
//  HLTDiaryTableViewCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/12.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTDiaryTableViewCell.h"
#define DiaryCellHeight 140

@implementation HLTDiaryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self CreateCell];
    }
    return self;
}

-(void)CreateCell
{
    CGFloat yPoint = 15.0;
    CGFloat width = DiaryCellHeight;
    CGFloat height = DiaryCellHeight - yPoint * 2;
    CGFloat xPoint = kMainWidth - 10 - width;
    
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [self.contentView addSubview:_imageview];
    
    width = kMainWidth - 20 - width;
    xPoint = 10.0;
    height = (DiaryCellHeight - yPoint * 2 )/5*2;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    [_titleLabel labelWithText:_liveDiary.title andTextColor:[UIColor blackColor] andFontSize:KFont+3 andBackgroundColor:nil];
    _titleLabel.numberOfLines = 1;
    [self.contentView addSubview:_titleLabel];
    
    
    yPoint = yPoint + height +10;
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _contentLabel.numberOfLines = 2;
    [_contentLabel labelWithText:_liveDiary.content andTextColor:[UIColor lightGrayColor] andFontSize:KFont-4 andBackgroundColor:nil];
    [self.contentView addSubview:_contentLabel];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setLiveDiary:(HLTLiveDiary *)liveDiary
{
    _titleLabel.text = liveDiary.title;
    _contentLabel.text = [NSString stringWithFormat:@"%@  %@",liveDiary.time,liveDiary.content];
    _imageview.image = [UIImage imageFileNamed:liveDiary.imageName andType:YES];
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
