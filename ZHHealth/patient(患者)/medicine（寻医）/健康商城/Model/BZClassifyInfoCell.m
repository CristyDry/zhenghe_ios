//
//  BZClassifyInfoCell.m
//  ZHHealth
//
//  Created by pbz on 15/12/1.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZClassifyInfoCell.h"
@interface BZClassifyInfoCell ()

@property (nonatomic,strong)  UIImageView *iconView;
@property (nonatomic,strong)  UILabel *label;

@end
@implementation BZClassifyInfoCell

// 创建可以重用的自定义cell的对象
+ (instancetype)BZClassifyInfoCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"classifyInfoCell";
    BZClassifyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子控件
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 40, 40)];
        [iconView.layer setCornerRadius:CGRectGetHeight(iconView.bounds)/2];
        iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 20, iconView.frame.origin.y, 200, iconView.bounds.size.height)];
        [self.contentView addSubview:label];
        self.label = label;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setInfos:(BZClassifyAccount *)infos{

    // 给子控件赋值
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:infos.avatar]];
    self.label.text = infos.classifyName;
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
