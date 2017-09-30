//
//  HLTPatientTableViewCell.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTPatientTableViewCell.h"

@implementation HLTPatientTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self CreateCell];
    }
    return self;
}

-(void)CreateCell
{
    CGFloat yPoint = 10.0;
    CGFloat width = 60.0;
    CGFloat xPoint = 10.0;
    CGFloat height = 60.0;
    //患者头像
    _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
    _avatarImage.layer.cornerRadius = height*0.5;
    _avatarImage.clipsToBounds = YES;
    [self.contentView addSubview:_avatarImage];
    
    width = 60.0;
    height = AUTO_MATE_HEIGHT(20);
    _statuButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth-xPoint-width,(width+yPoint*2-height)*0.5, width, height)];
    [self.contentView addSubview:_statuButton];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImage.frame)+xPoint, yPoint+5, kMainWidth-yPoint*4-160, 15)];
    [self.contentView addSubview:_nameLabel];
    
    _verifyContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImage.frame)+xPoint, CGRectGetMaxY(_nameLabel.frame)+yPoint, kMainWidth-yPoint*4-width*2, 40)];
    _verifyContentLabel.font = [UIFont systemFontOfSize:14];
    _verifyContentLabel.numberOfLines = 2;
    [self.contentView addSubview:_verifyContentLabel];
    
}

-(void)setPatient:(HLTPatient *)patient
{
    _patient = patient;
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:patient.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    _nameLabel.text = patient.name;
    _verifyContentLabel.text = patient.verifyContent;
    
    
    if ([patient.status isEqualToString:@"已同意"])
    {
        [_statuButton setTitle:@"已同意" forState:UIControlStateNormal];
        [_statuButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    else
    {
        _statuButton.layer.borderColor = kBackgroundColor.CGColor;
        _statuButton.layer.borderWidth = 1;
        _statuButton.layer.cornerRadius = 5;
        _statuButton.clipsToBounds = YES;
        [_statuButton setBackgroundImage:[UIImage imageNamed:@"背景-拷贝"] forState:UIControlStateNormal];
        [_statuButton setTitle:@"同意" forState:UIControlStateNormal];
        [_statuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_statuButton addTarget:self action:@selector(statuButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - 点击事件
-(void)statuButtonEvent
{
    HLTPatient * patient = _patient;
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = patient.ID;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/agreeApply" args:args targetVC:nil response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            [_statuButton setTitle:@"已同意" forState:UIControlStateNormal];
            [_statuButton setBackgroundColor:[UIColor  whiteColor]];
            [_statuButton setBackgroundImage:nil forState:UIControlStateNormal];
            [_statuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self isStatus];
        }
    }];
}

-(void)isStatus
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"同意成功";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
