//
//  HLTCdlistCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/31.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTCdlistCell.h"

@implementation HLTCdlistCell




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

-(void)createCell
{
    CGFloat xPoint = AUTO_MATE_WIDTH(10);
    CGFloat yPoint = AUTO_MATE_HEIGHT(10);
    CGFloat width = kMainWidth-xPoint*2;
    CGFloat height = AUTO_MATE_HEIGHT(110);
    
    _bgView = [[UIView alloc] init];//WithFrame:CGRectMake(xPoint, 0, width, height)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 5;
    _bgView.clipsToBounds = YES;
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgView.layer.borderWidth = 1;
    [self.contentView addSubview:_bgView];
    
//    UIImageView * lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint*4, _bgView.maxY_wcr, 1, yPoint*2-2)];
//    lineImage.backgroundColor = [UIColor blackColor];
//    [self.contentView addSubview:lineImage];
    
    height = AUTO_MATE_HEIGHT(20);
    width = width-AUTO_MATE_WIDTH(100)-xPoint*2;
    _incidentLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _incidentLabel.font = [UIFont systemFontOfSize:16];
    [_bgView addSubview:_incidentLabel];
    
    _updateDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_incidentLabel.maxX_wcr, yPoint, kMainWidth-xPoint*3-_incidentLabel.maxX_wcr, height)];
    _updateDateLabel.textAlignment = NSTextAlignmentRight;
    _updateDateLabel.textColor = [UIColor grayColor];
    _updateDateLabel.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:_updateDateLabel];
    
    width = kMainWidth-xPoint*4;
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, _updateDateLabel.maxY_wcr, width, height)];
    _remarkLabel.font = [UIFont systemFontOfSize:15];
    [_bgView addSubview:_remarkLabel];
    
    width =kMainWidth-xPoint*2;
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, _remarkLabel.maxY_wcr,width , 1)];
    line.backgroundColor = kBackgroundColor;
    [_bgView addSubview:line];
    
    height = AUTO_MATE_HEIGHT(60);
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(xPoint, line.maxY_wcr, width, height)];
    [_bgView addSubview:_scrollview];
    
    
}

-(void)setCdlistModel:(cdList *)cdlistModel
{
    _incidentLabel.text = cdlistModel.incident;
    _updateDateLabel.text = cdlistModel.cdDate2;
    _remarkLabel.text = cdlistModel.remark;
    
    
    CGFloat height = AUTO_MATE_HEIGHT(45);
    if (cdlistModel.image.count>0) {
        
        for (int i = 0; i<cdlistModel.image.count; i++) {
            
            _image = [[UIImageView alloc] initWithFrame:CGRectMake((height+10)*i, 5, height, height)];
            
            [_image sd_setImageWithURL:[NSURL URLWithString:cdlistModel.image[i]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
            [_scrollview addSubview:_image];
        }
        
        _scrollview.contentSize = CGSizeMake(_image.maxX_wcr+90, height+AUTO_MATE_HEIGHT(10));
       
    }
    
    CGFloat xPoint = AUTO_MATE_WIDTH(10);
    CGFloat width = kMainWidth-xPoint*2;
    CGFloat yPoint = AUTO_MATE_HEIGHT(10);
    
    if (cdlistModel.image.count>0) {
        height = AUTO_MATE_HEIGHT(110);
    }else{
        height = AUTO_MATE_HEIGHT(60);
    }
    _bgView.frame = CGRectMake(xPoint, 0, width, height);
    UIImageView * lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint*4, _bgView.maxY_wcr, 1, yPoint*2-2)];
    lineImage.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:lineImage];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
