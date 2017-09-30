//
//  WCRKnowledgeCell.m
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//



#import "WCRKnowledgeCell.h"

@interface WCRKnowledgeCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *smallIV;

@end

@implementation WCRKnowledgeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat yPoint = 10.0;
        CGFloat height = kWCRKnowledgeCellHeight - yPoint * 2;
        CGFloat width = height;
        CGFloat xPoint = kMainWidth - 10 - width;
        _smallIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        _smallIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_smallIV];
        
        xPoint = 10.0;
        width = kMainWidth - width - xPoint * 3;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_titleLabel labelWithText:@"" andTextColor:kBlackColor andFontSize:KFont - 3 andBackgroundColor:nil];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
     
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, kWCRKnowledgeCellHeight - 1, kMainWidth - kBorder, 1)];
        line.backgroundColor = KLineColor;
        [self.contentView addSubview:line];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
    
}

-(void)setKnowledge:(BZArticleListModel *)knowledge {
    
    _titleLabel.text = knowledge.title;
    
    [_smallIV sd_setImageWithURL:[NSURL URLWithString:knowledge.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    
    
}


@end
