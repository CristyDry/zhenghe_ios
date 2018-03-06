//
//  HLTMycardViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/14.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTMycardViewController.h"


@interface HLTMycardViewController ()


@end

@implementation HLTMycardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码名片";
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self createIconImageview];
    
    
}
#pragma mark - 添加Imageview
-(void)createIconImageview
{
    //背景圆角矩形
    CGFloat xPoint = AUTO_MATE_WIDTH(30);
    CGFloat yPoint = AUTO_MATE_HEIGHT(20);
    CGFloat width = kMainWidth - xPoint *2;
    CGFloat height = AUTO_MATE_HEIGHT(400);
    UIImageView * bigView = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint,KTopLayoutGuideHeight+ yPoint, width , height)];
    bigView.backgroundColor = [UIColor whiteColor];
    bigView.layer.cornerRadius = 10;
    bigView.clipsToBounds = YES;
    bigView.layer.borderWidth = 1;
    bigView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bigView.userInteractionEnabled = YES;
    [self.view addSubview:bigView];
    
    //label1
    UILabel * pleaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPoint, width, 30)];
    pleaseLabel.textAlignment = NSTextAlignmentCenter;
    pleaseLabel.text = @"请用户打开App扫描下面二维码";
    pleaseLabel.font = [UIFont systemFontOfSize:16];
    pleaseLabel.lineBreakMode = NSLineBreakByWordWrapping;
    pleaseLabel.numberOfLines = 2;
    pleaseLabel.textColor = [UIColor grayColor];
    
    [bigView addSubview:pleaseLabel];
    
    
    //二维码
    
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    CIImage *ciImage = [self createQRForString:account.Id];
    UIImage *uiImage = [self createNonInterpolatedUIImageFormCIImage:ciImage withSize:AUTO_MATE_WIDTH(150)];
    
    CGFloat  width1 = AUTO_MATE_WIDTH(150);
    xPoint = (bigView.frame.size.width-width1)*0.5;
    UIImageView * erweimaImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, pleaseLabel.maxY_wcr+yPoint*1.5, width1, width1)];
    erweimaImage.image = uiImage;
    [bigView addSubview:erweimaImage];
    erweimaImage.layer.shadowOffset = CGSizeMake(0, 0.5);  // 设置阴影的偏移量
    erweimaImage.layer.shadowRadius = 1;  // 设置阴影的半径
    erweimaImage.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    erweimaImage.layer.shadowOpacity = 0.3; // 设置阴影的不透明度
    
    // 二维码中的头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.width_wcr = erweimaImage.width_wcr * 0.3;
    iconView.height_wcr = erweimaImage.height_wcr * 0.3;
    iconView.centerX_wcr = erweimaImage.centerX_wcr;
    iconView.centerY_wcr = erweimaImage.centerY_wcr;
    iconView.layer.cornerRadius = iconView.bounds.size.height * 0.5;
    iconView.layer.masksToBounds = YES;
    [iconView sd_setImageWithURL:[NSURL URLWithString:account.avatar]];
    [bigView addSubview:iconView];
    
    
    //医生信息
    yPoint = AUTO_MATE_HEIGHT(15);
    //姓名
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, erweimaImage.maxY_wcr+yPoint, width, 20)];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = account.doctor;
    [bigView addSubview:nameLabel];
    
    yPoint = AUTO_MATE_HEIGHT(10);
    //专业
    UILabel * proLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.maxY_wcr+yPoint, width, 22)];
    proLabel.font = [UIFont systemFontOfSize:20];
    proLabel.textAlignment = NSTextAlignmentCenter;
    proLabel.text = account.professional;
    [bigView addSubview:proLabel];
    
    //医院
    UILabel * hosLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, proLabel.maxY_wcr+yPoint, width, 18)];
    hosLabel.font = [UIFont systemFontOfSize:17];
    hosLabel.textAlignment = NSTextAlignmentCenter;
    hosLabel.text = account.hospital;
    [bigView addSubview:hosLabel];
    
}

- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



@end
