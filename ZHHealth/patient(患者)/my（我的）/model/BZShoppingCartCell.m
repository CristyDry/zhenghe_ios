//
//  BZShoppingCartCell.m
//  ZHHealth
//
//  Created by pbz on 15/11/24.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZShoppingCartCell.h"
@interface BZShoppingCartCell ()

/**显示是否选中商品**/
@property (weak, nonatomic) IBOutlet UIButton *selectGoods;
/**显示选中的产品数量**/
@property (weak, nonatomic) IBOutlet UITextField *showNumberTF;
/**显示商品图片**/
@property (weak, nonatomic) IBOutlet UIImageView *showPic;
/**显示商品名称**/
@property (weak, nonatomic) IBOutlet UIButton *showTitleBtn;
/**显示商品规格**/
@property (weak, nonatomic) IBOutlet UILabel *showFormatLb;
/**显示商品总数**/
@property (weak, nonatomic) IBOutlet UILabel *showtotalLb;
/**显示总花费**/
@property (weak, nonatomic) IBOutlet UILabel *showCostLb;
/**减少按钮**/
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;

@property (nonatomic,strong)  LoginResponseAccount *account;

@property (nonatomic,strong)  NSString *productId;

@property (nonatomic,assign)  CGFloat cost;
@end

@implementation BZShoppingCartCell

// 创建自定义cell的类方法
+ (instancetype)cellWithTableView:(UITableView *)tableView{

    BZShoppingCartCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BZShoppingCartCell" owner:self options:nil] lastObject];

    return cell;
}

// 选中商品
- (IBAction)selectGoodsClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    // 设置模型中是否选中的字段
    if (sender.selected) {
        _shoppingCartModel.isSelected = YES;
    }else{
        _shoppingCartModel.isSelected = NO;
    }
    // 设置全选按钮状态
//    if ([_delegate respondsToSelector:@selector(isAllSelecteds:)]) {
//        [_delegate isAllSelecteds:_isAllSelected ];
//    }
    if ([_delegate respondsToSelector:@selector(setAllCost)]) {
        [_delegate setAllCost];
    }
}

// 减少商品
- (IBAction)reduceClick:(UIButton *)sender {
    
    int number = [_showNumberTF.text intValue];
    if (number == 1) {
        sender.enabled = NO;
    }else{
        number--;
        _showNumberTF.text = [NSString stringWithFormat:@"%d",number];
        [self calculateWithNum:number];
    }
 
}
// 增加商品
- (IBAction)increaseClick:(UIButton *)sender {
    _reduceBtn.enabled = YES;
    NSInteger number = [_showNumberTF.text intValue];
    number++;
    [self calculateWithNum:number];

}

- (void)calculateWithNum:(NSInteger )number{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"patientId"] = _account.Id;
    args[@"productId"] = _productId;
    args[@"count"] = [NSString stringWithFormat:@"%ld",number];
    
    [httpUtil doPostRequest:@"api/orderApiController/addToBuyCar" args:args targetVC:nil response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            _showtotalLb.text = [NSString stringWithFormat:@"共 %ld 件商品",number];
            CGFloat cost = number * _shoppingCartModel.realityPrice;
            _shoppingCartModel.sumPrice = cost;
            if ([_delegate respondsToSelector:@selector(setAllCost)]) {
                [_delegate setAllCost];
            }
            _showCostLb.text = [NSString stringWithFormat:@"小计：￥%.2f",cost];
            _showNumberTF.text = [NSString stringWithFormat:@"%ld",number];
        }
    }];
}
- (void)setShoppingCartModel:(BZShoppingCartModel *)shoppingCartModel{
    
    _shoppingCartModel = shoppingCartModel;
    _productId = shoppingCartModel.productId;
    // 图片
    [_showPic sd_setImageWithURL:[NSURL URLWithString:shoppingCartModel.productPic] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    // 名称
    [_showTitleBtn setTitle:shoppingCartModel.productName forState:UIControlStateNormal];
    // 规格
    _showFormatLb.text = shoppingCartModel.standard;
    // 总数
    _showtotalLb.text = [NSString stringWithFormat:@"共 %@ 件商品",shoppingCartModel.count];
    // 小计
    CGFloat cost = [_shoppingCartModel.count intValue] * _shoppingCartModel.realityPrice;
    _showCostLb.text = [NSString stringWithFormat:@"小计：￥%0.2f",cost];
    _showNumberTF.text = shoppingCartModel.count;
    // 是否选中
    _selectGoods.selected = shoppingCartModel.isSelected;
}

- (void)awakeFromNib{
    _account = [LoginResponseAccount decode];
}

- (void)setIsAllSelected:(BOOL)isAllSelected{
    if (isAllSelected == YES) {
        _selectGoods.selected = YES;
        _shoppingCartModel.isSelected = YES;
    }else{
        _selectGoods.selected = NO;
        _shoppingCartModel.isSelected = NO;
    }
    if ([_delegate respondsToSelector:@selector(setAllCost)]) {
        [_delegate setAllCost];
    }
}



@end
