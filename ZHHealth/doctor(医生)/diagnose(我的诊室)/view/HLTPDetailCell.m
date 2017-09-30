//
//  HLTPDetailCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/26.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTPDetailCell.h"

@implementation HLTPDetailCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}


-(void)createCell
{
    
    CGFloat xPoint = 20;
    CGFloat yPoint = 10;
    CGFloat width = 200;
    CGFloat height = 20;
    _textlabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _textlabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_textlabel];
    
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth-xPoint-width-yPoint, yPoint, width, height)];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_contentLabel];
    
    
    
}

-(void)setTextString:(NSString *)textString
{
    _textlabel.text = textString;
}

-(void)setHuanzheModel:(huanzhe *)huanzheModel
{
    if ([_textlabel.text isEqualToString:@"性别"]) {
        _contentLabel.text = huanzheModel.gender;
    }else if ([_textlabel.text isEqualToString:@"年龄"]){
        _contentLabel.text = huanzheModel.age;
    }else{
        _contentLabel.text = huanzheModel.address;
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
