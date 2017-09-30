//
//  BZMessageCell.m
//  ZHHealth
//
//  Created by pbz on 15/12/11.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZMessageCell.h"

#define KBZMessageCellHeight 60

@interface BZMessageCell()
/** 名称*/
@property (nonatomic,strong)  UILabel *nameLabel;
/** 头像*/
@property (nonatomic,strong)  UIImageView *iconView;
/** 消息*/
@property (nonatomic,strong)  UILabel *messageLabel;

@end
@implementation BZMessageCell

+ (instancetype)BZMessageCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"BZMessageCell";
    BZMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子控件
        // 1.头像
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        [iconView.layer setCornerRadius:CGRectGetHeight(iconView.bounds)/2];
        iconView.layer.masksToBounds = YES;
         iconView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        // 2.医生名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 20, 0, 200, KBZMessageCellHeight * 0.5)];
        nameLabel.font = [UIFont systemFontOfSize:KFont - 4];
        nameLabel.textColor = kBlackColor;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        // 3.消息
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame), kMainWidth - nameLabel.frame.origin.x - 20, KBZMessageCellHeight * 0.5)];
        [self.contentView addSubview:messageLabel];
        messageLabel.font = [UIFont systemFontOfSize:KFont - 6];
        messageLabel.textColor = kGrayColor;
        self.messageLabel = messageLabel;
        
    }
    return self;
}

- (void)setRequestAndNotifyModel:(BZRequestAndNotifyModel *)requestAndNotifyModel{
    self.nameLabel.text = @"林冲";
    self.messageLabel.text = @"123456";
//    // 给子控件赋值
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:requestAndNotifyModel.avatar]];
//    self.nameLabel.text = requestAndNotifyModel.doctor;
//    self.messageLabel.text = requestAndNotifyModel
}

@end
