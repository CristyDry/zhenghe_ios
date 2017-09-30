//
//  WCRExpertCell.m
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WCRExpertCell.h"

@interface WCRExpertCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *officeTypeLabel; // 科室和医生类别

@property (nonatomic, strong) UILabel *hospitalLabel;

@property (nonatomic, strong) UILabel *skillLabel;   // 主治

@end

@implementation WCRExpertCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIButton *borderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        borderBtn.frame = CGRectMake(10.0, 0.0, kMainWidth - 20.0, kWCRExpertCellHeight);
        [borderBtn setBorderOfButton];
        borderBtn.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:borderBtn];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10.0, 0.0, kMainWidth - 20.0, kWCRExpertCellHeight)];
        bgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bgView];
        
        CGFloat width = 70;
        CGFloat height = width;
        CGFloat xPoint = (bgView.width_wcr - width) / 2.0;
        CGFloat yPoint = 10.0;
        
        _iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        [_iconIV imageViewWithImageName:@"" andModeScaleAspectFill:YES andCorner:width / 2.0];
        [bgView addSubview:_iconIV];
        
        xPoint = 10.0;
        yPoint = _iconIV.maxY_wcr + 10;
        width = bgView.width_wcr - xPoint * 2;
        height = 30.0;
        
        _nameLabel = [self setLabelPropertyWithTextColor:kBlackColor andFont:KFont - 2 andRect:CGRectMake(xPoint, yPoint, width, height)];
        [bgView addSubview:_nameLabel];
        
        yPoint = _nameLabel.maxY_wcr;
        _officeTypeLabel = [self setLabelPropertyWithTextColor:kGrayColor andFont:KFont - 5 andRect:CGRectMake(xPoint, yPoint, width, height)];
        [bgView addSubview:_officeTypeLabel];
        
        yPoint = _officeTypeLabel.maxY_wcr;
        _hospitalLabel = [self setLabelPropertyWithTextColor:kGrayColor andFont:KFont - 5 andRect:CGRectMake(xPoint, yPoint, width, height)];
        [bgView addSubview:_hospitalLabel];
        
        yPoint = _hospitalLabel.maxY_wcr - 1 + 10;
        [self setLineWithRect:CGRectMake(0.0, yPoint, width, 1) withSuperView:bgView];
        
        yPoint = _hospitalLabel.maxY_wcr + 10;
        height = 30;
        _skillLabel = [self setLabelPropertyWithTextColor:kBlackColor andFont:KFont - 4 andRect:CGRectMake(xPoint, yPoint, width, height)];
        [self.contentView addSubview:_skillLabel];
        
        yPoint = _skillLabel.maxY_wcr - 1;
//        [self setLineWithRect:CGRectMake(0.0, yPoint, width, 1) withSuperView:bgView];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
    
}

-(UILabel*)setLabelPropertyWithTextColor:(UIColor*)textColor andFont:(CGFloat)fontSize andRect:(CGRect)frame {
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    [label labelWithText:@"" andTextColor:textColor andFontSize:fontSize andBackgroundColor:nil];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
    
}

-(void)setLineWithRect:(CGRect)frame withSuperView:(UIView*)superView{
    UILabel *line1 = [[UILabel alloc]initWithFrame:frame];
    line1.backgroundColor = KLineColor;
    [superView addSubview:line1];
}

-(void)setDoctor:(BZDoctorModel *)doctor {
    
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:doctor.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    
    _nameLabel.text = doctor.doctor;
    
    _officeTypeLabel.text = [NSString stringWithFormat:@"%@  %@",doctor.department,doctor.professional];
    
    _hospitalLabel.text = doctor.hospital;
    
    _skillLabel.text = [NSString stringWithFormat:@" %@ ",doctor.professionalField];
    
}

@end
