//
//  BZLeftRecordCell.m
//  ZHHealth
//
//  Created by pbz on 15/12/22.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZLeftRecordCell.h"
#define marginX 15

@interface BZLeftRecordCell ()

@property (nonatomic,strong)  UILabel *titleLabel;
@property (nonatomic,strong)  UILabel *contentLabel;
@property (nonatomic,strong)  UIImageView *pictureView;

@end
@implementation BZLeftRecordCell

// 重写init方法，重新创建cell内部子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier images:(NSArray *) images{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (images.count > 0) {
            // 有图片
            // 标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, kMainWidth - 75 - marginX * 2, 35)];
            titleLabel.font = [UIFont systemFontOfSize:17];
            [self.contentView addSubview:titleLabel];
            _titleLabel = titleLabel;
            // 内容
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 35, kMainWidth - 75 - marginX * 2, 34)];
            contentLabel.font = [UIFont systemFontOfSize:13];
//            contentLabel.textColor = [UIColor lightGrayColor];
            contentLabel.numberOfLines = 2;
            [self.contentView addSubview:contentLabel];
            _contentLabel = contentLabel;
            // 图片
            UIImageView *pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel.frame) + 10, 8, 70, 54)];
            [self.contentView addSubview:pictureView];
            _pictureView = pictureView;

        }else if (images == nil) {
            // 无图片
            // 标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, kMainWidth - marginX * 2, 35)];
            titleLabel.font = [UIFont systemFontOfSize:17];
            [self.contentView addSubview:titleLabel];
            _titleLabel = titleLabel;
            // 内容
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 35, kMainWidth - marginX * 2, 34)];
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.textColor = [UIColor lightGrayColor];
            contentLabel.numberOfLines = 2;
            [self.contentView addSubview:contentLabel];
             _contentLabel = contentLabel;
        }
    }
    return self;
}
// 给子控件赋值
- (void)setLeftRecordInfo:(BZLeftRecordModel *)leftRecordInfo{
    _leftRecordInfo = leftRecordInfo;
    _titleLabel.text = leftRecordInfo.title;
    // 把时间NSString转化成NSDate
    NSString* stringTime = leftRecordInfo.updateDate;
//    NSString* stringTime = @"2016-01-10 11:11:11";
    NSDate *date = [Tools dateFromString:stringTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yy/MM/dd"];
    NSString *destDate= [dateFormatter stringFromDate:date];
    NSString *text2 = [NSString stringWithFormat:@"%@ %@",destDate,leftRecordInfo.content];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text2];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,8)];
    _contentLabel.attributedText = str;
//   NSString *marginTime = [self compareCurrentTime:inputDate];

//    if (marginTime) {
//        NSString *text1 = [marginTime stringByAppendingString:leftRecordInfo.content];
//        NSLog(@"text1text1:%@",text1);
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text1];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,2)];
//        _contentLabel.attributedText = str;
//    }else{
//        [inputFormatter setDateFormat:@"yy/MM/dd"];
//        NSString *string2 = [inputFormatter stringFromDate:inputDate];
//        NSString *text2 = [string2 stringByAppendingString:leftRecordInfo.content];
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text2];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,8)];
//        _contentLabel.attributedText = str;
//    }
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:leftRecordInfo.image[0]]];

}


- (NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        
        result = [NSString stringWithFormat:@"刚刚 "];
        
    }else if((temp = timeInterval/60) <60){
        
        result = @"今天 ";
        
    }else if((temp = temp/60) <24){
        
        result = @"今天 ";
        
    }else if((temp = temp/24) <1){
         result = @"昨天 ";
        
    }else if((temp = temp/24) <2){
        result = @"前天 ";
        
    }
    
//    else if((temp = temp/24) <30){
//        result = [NSString stringWithFormat:@"%ld天前",temp];
//    }
//    
//    else if((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%ld月前",temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前",temp];
//    }
    
    return  result;
}

@end
