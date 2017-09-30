//
//  BZRequestCell.m
//  ZHHealth
//
//  Created by pbz on 15/12/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZRequestCell.h"
#define KBZRequestCellHeight 80
@interface BZRequestCell()
// 头像
@property (nonatomic,strong)  UIImageView *iconView;
// 名称
@property (nonatomic,strong)   UILabel *nameLabel;
// 同意
@property (nonatomic,strong)  UILabel *agreeLabel;
// 消息
@property (nonatomic,strong)   UILabel *messageLabel;

@end

@implementation BZRequestCell

+ (instancetype)BZRequestCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"BZRequestCell";
    BZRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子控件
        // 1. 头像
        CGFloat marginH = 20;
        CGFloat marginV = 10;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(marginH, marginV, KBZRequestCellHeight - marginV * 2, KBZRequestCellHeight - marginV * 2)];
        [iconView.layer setCornerRadius:CGRectGetHeight(iconView.bounds) * 0.5];
        iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        // 2. 名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 30, iconView.frame.origin.y, 150, KBZRequestCellHeight * 0.5 - marginV)];
        nameLabel.font = [UIFont systemFontOfSize:KFont - 4];
        nameLabel.textColor = kBlackColor;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        // 3. 右边同意/待同意
        UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainWidth - 60, 0, 50, KBZRequestCellHeight )];
        [self.contentView addSubview:agreeLabel];
        agreeLabel.font = [UIFont systemFontOfSize:KFont - 6];
        agreeLabel.textColor = kGrayColor;
        self.agreeLabel = agreeLabel;
        // 4. 消息
        CGFloat messageLabelW = kMainWidth - nameLabel.frame.origin.x - agreeLabel.frame.size.width - marginH - 10;
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame), messageLabelW, KBZRequestCellHeight * 0.5 - marginV)];
        [self.contentView addSubview:messageLabel];
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:KFont - 8];
        messageLabel.textColor = kGrayColor;
        self.messageLabel = messageLabel;
       
    }
    return self;
}

- (void)setRequestAndNotifyModel:(BZRequestAndNotifyModel *)requestAndNotifyModel{
    _requestAndNotifyModel = requestAndNotifyModel;
//    self.iconView.image = [UIImage imageNamed:@"医生头像"];
//    self.nameLabel.text = @"王永学";
//    self.agreeLabel.text = @"待同意";
//    self.messageLabel.text = @"王医生，您好！我是今天在医院门诊给你看过的患者";
    [_iconView sd_setImageWithURL:[NSURL URLWithString:requestAndNotifyModel.avatar]];
    _nameLabel.text = requestAndNotifyModel.doctor;
    _agreeLabel.text = requestAndNotifyModel.status;
    _messageLabel.text = requestAndNotifyModel.content;
    
}


@end
