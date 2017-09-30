//
//  BZSearchResultCell.m
//  ZHHealth
//
//  Created by pbz on 15/12/1.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZSearchResultCell.h"
#import "BZProductListModel.h"
#define mainWidth [UIScreen mainScreen].bounds.size.width
#define mainHeight [UIScreen mainScreen].bounds.size.height

@interface BZSearchResultCell ()
// 右边
@property (nonatomic,strong)  UIImageView *imageViewR;
@property (nonatomic,strong)  UILabel *productNameR;
@property (nonatomic,strong)  UILabel *standardR;
@property (nonatomic,strong)  UILabel *priceR;
@property (nonatomic,strong)  UIView *rightView;
@property (nonatomic,strong)  UIImageView *typeR;
// 左边
@property (nonatomic,strong)  UIImageView *imageViewL;
@property (nonatomic,strong)  UILabel *productNameL;
@property (nonatomic,strong)  UILabel *standardL;
@property (nonatomic,strong)  UILabel *priceL;
@property (nonatomic,strong)  UIImageView *typeL;
@property (nonatomic,strong)  UIView *leftView;
@property (nonatomic,assign)  CGFloat imageViewMaxX;

@property (nonatomic, copy) NSString *leftID;
@property (nonatomic, copy) NSString *rightID;

@end
@implementation BZSearchResultCell

+ (BZSearchResultCell *)searchResultCellWithTableView:(UITableView *)tableView{

    
    // 创建可重用cell
    static NSString *reuseID = @"searchResultCell";
    BZSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    // 返回cell
    return cell;

}

// 重写init方法，重新创建cell内部子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{


    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubViewLeft];
        
        UIView *VseparationLine = [[UIView alloc] initWithFrame:CGRectMake(_imageViewMaxX + 10, 0, 1, _typeLabelMaxY + 5)];
        VseparationLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:VseparationLine];
        
        [self createSubViewRight];
        
        UIView *HseparationLine = [[UIView alloc] initWithFrame:CGRectMake(0, _typeLabelMaxY + 5, mainWidth, 1)];
        HseparationLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:HseparationLine];

    }
    return self;
}
// 左边子控件
- (void)createSubViewLeft{
    UIView *LeftView = [[UIView alloc] init];
    [self.contentView addSubview:LeftView];
    _leftView = LeftView;
    // 添加左边视图手势跳转
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftviewTap)];
    [self.leftView addGestureRecognizer:leftTap];
    // 图片
    CGFloat Vmargin = 5;
    CGFloat Hmargin = 10;
    CGFloat width = (mainWidth - Hmargin * 2 - 30) * 0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, Hmargin, width, width * 0.68)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [LeftView addSubview:imageView];
    _imageViewL = imageView;
    CGFloat imageViewX = imageView.frame.origin.x;
    _imageViewMaxX = CGRectGetMaxX(imageView.frame);
    // 产品名称
    UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(imageViewX + Vmargin, CGRectGetMaxY(imageView.frame) + Vmargin, width, 35)];
    [productName setFont:[UIFont systemFontOfSize:15]];
    productName.numberOfLines = 0;
    [LeftView addSubview:productName];
    _productNameL = productName;
    // 产品规格
    UILabel *standard = [[UILabel alloc] initWithFrame:CGRectMake(imageViewX, CGRectGetMaxY(productName.frame), width, 15)];
    [standard setFont:[UIFont systemFontOfSize:15]];
    [LeftView addSubview:standard];
    _standardL = standard;
    // 价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(imageViewX, CGRectGetMaxY(standard.frame) + Vmargin, width - 35, 15)];
    [price setFont:[UIFont systemFontOfSize:15]];
    [price setTextColor:[UIColor redColor]];
    [LeftView addSubview:price];
    _priceL = price;
    // 类型
    UIImageView *typeL = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) - 30, price.frame.origin.y, 30, price.bounds.size.height)];
    [LeftView addSubview:typeL];
    _typeL = typeL;
    _typeLabelMaxY = CGRectGetMaxY(typeL.frame);
    LeftView.frame = CGRectMake(0, 0, mainWidth * 0.5 - 1, _typeLabelMaxY);
}
// 右边子控件
- (void)createSubViewRight{
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:rightView];
    _rightView = rightView;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightviewTap)];
    [self.rightView addGestureRecognizer:rightTap];
    // 图片
    CGFloat Vmargin = 5;
    CGFloat Hmargin = 10;
    CGFloat width = (mainWidth - Hmargin * 2 - 30) * 0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Hmargin, Hmargin, width, width * 0.68)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [rightView addSubview:imageView];
    _imageViewR = imageView;
    CGFloat imageViewX = imageView.frame.origin.x;
    // 产品名称
    UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(imageViewX + Vmargin, CGRectGetMaxY(imageView.frame) + Vmargin, width, 35)];
    [productName setFont:[UIFont systemFontOfSize:15]];
    productName.numberOfLines = 0;
    [rightView addSubview:productName];
    _productNameR = productName;
    // 产品规格
    UILabel *standard = [[UILabel alloc] initWithFrame:CGRectMake(imageViewX, CGRectGetMaxY(productName.frame), width, 15)];
    [standard setFont:[UIFont systemFontOfSize:15]];
    [rightView addSubview:standard];
    _standardR = standard;
    // 价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(imageViewX, CGRectGetMaxY(standard.frame) + Vmargin, width - 35, 15)];
    [price setTextColor:[UIColor redColor]];
    [price setFont:[UIFont systemFontOfSize:15]];
    [rightView addSubview:price];
    _priceR = price;
    // 类型
    UIImageView *typeR = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) - 30, price.frame.origin.y, 30, price.bounds.size.height)];
    [rightView addSubview:typeR];
    _typeR = typeR;
    _typeLabelMaxY = CGRectGetMaxY(typeR.frame);
    rightView.frame = CGRectMake(mainWidth * 0.5 + 1, 0, mainWidth * 0.5, _typeLabelMaxY);
}
// 左边手势
- (void)leftviewTap{
    NSLog(@"左边");
    NSLog(@"%@",self.leftID);
    if ([_delegate respondsToSelector:@selector(pushProductDetailController:)]) {
        [_delegate pushProductDetailController:self.leftID];
        
    }
    
}
//
- (void)rightviewTap{
   NSLog(@"右边");
    NSLog(@"%@",self.rightID);
    if ([_delegate respondsToSelector:@selector(pushProductDetailController:)]) {
        [_delegate pushProductDetailController:self.rightID];
    }
}

// 给子控件赋值
- (void)setProductInfo:(BZProductListModel *)productListModel atIndex:(NSInteger)index{
    if (index == 0) {
        // 给左边子控件赋值
        if (productListModel == nil) {
            _leftView.hidden = YES;
        }else{
            _leftView.hidden = NO;
            [_imageViewL sd_setImageWithURL:[NSURL URLWithString:productListModel.productPic]];
            _productNameL.text = productListModel.productName;
            _standardL.text = productListModel.standard;
            _priceL.text = [NSString stringWithFormat:@"￥%0.2f",productListModel.price];
            if ([productListModel.type isEqualToString:@"otc"]) {
                _typeL.image = [UIImage imageNamed:@"otc"];
            }else{
                _typeL.image = [UIImage imageNamed:@"rx"];
            }
            _leftID = productListModel.ID;
        }
    }else if (index == 1){
        // 给右边子控件赋值
        if (productListModel == nil) {
            _rightView.hidden = YES;
        }else{
            _rightView.hidden = NO;
            [_imageViewR sd_setImageWithURL:[NSURL URLWithString:productListModel.productPic]];
            _productNameR.text = productListModel.productName;
            _standardR.text = productListModel.standard;
            _priceR.text = [NSString stringWithFormat:@"￥%0.2f",productListModel.price];
            if ([productListModel.type isEqualToString:@"otc"]) {
                _typeR.image = [UIImage imageNamed:@"otc"];
            }else{
                _typeR.image = [UIImage imageNamed:@"rx"];
            }
            _rightID = productListModel.ID;

        }
    }
    
}



@end
