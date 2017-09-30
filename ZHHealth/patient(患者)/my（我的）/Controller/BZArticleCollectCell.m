//
//  BZArticleCollectCell.m
//  ZHHealth
//
//  Created by pbz on 15/12/16.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZArticleCollectCell.h"
@interface BZArticleCollectCell ()

@property (nonatomic, strong) UIImageView *pictureView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@end
@implementation BZArticleCollectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat marginX = 10;
        // 文章标题
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginX, 0, kMainWidth * 0.67, kMainWidth * 0.11)];
        _titleLabel.font = [UIFont systemFontOfSize:KFont - 2];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kBlackColor;
        [self.contentView addSubview:_titleLabel];
        
        // 内容
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginX, CGRectGetMaxY(_titleLabel.frame), _titleLabel.bounds.size.width, kMainWidth * 0.11)];
        _detailLabel.font = [UIFont systemFontOfSize:KFont - 6];
        _detailLabel.numberOfLines = 2;
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        // 图片
        _pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame) + marginX, 8, kMainWidth - CGRectGetMaxX(_titleLabel.frame) - marginX * 2, kMainWidth * 0.22 - 16)];
        _pictureView.contentMode = UIViewContentModeScaleToFill;
        _pictureView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_pictureView];
    
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setArticleListModel:(BZCollectArticleListModel *) articleListModel{
    _articleListModel = articleListModel;
    _titleLabel.text = articleListModel.title;
    _detailLabel.text = articleListModel.content;
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:articleListModel.avatar]];
    
}


@end
