//
//  BZEditLeftRecordController.m
//  ZHHealth
//
//  Created by pbz on 15/12/23.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "BZEditLeftRecordController.h"
#import "BZAddLeftRecordController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"

@interface BZEditLeftRecordController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)  UIView *topView;
@property (nonatomic,strong)  UITextField *titleField;
@property (nonatomic,strong)  UITextView *contentView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic,strong)  UIImageView *imageView;
@property (nonatomic,strong)  UIButton *addPictureBtn;
@property (nonatomic,strong)  NSMutableArray *imagesA;
@property (nonatomic,strong)  UIScrollView *scrollview;

@end

@implementation BZEditLeftRecordController

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.hidesBackButton = YES;
    //    self.view.backgroundColor = [UIColor colorWithRGB:245 G:245 B:245];
    [self setNavigationBar];
    [self setCustomUI];
}

#pragma mark - 设置导航栏
- (void)setNavigationBar{
    // 白色背景
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, 44)];
     TPKeyboardAvoidingScrollView *topView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:topView];
    _topView = topView;
    
    // 左边的返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backLeftNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    // 保存
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainWidth - 54, 0, 44, 44)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveLeftRecord) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:saveBtn];
    
}
//setCustomUI
- (void)setCustomUI{
    // 标题
    UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, kMainWidth , 44)];
    titleField.backgroundColor = [UIColor whiteColor];
    titleField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    titleField.layer.borderWidth = 1;
    titleField.text = _leftRecordInfo.title;
    _titleField = titleField;
    [self.view addSubview:titleField];
    // 内容
    UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleField.frame), kMainWidth, kMainWidth * 0.8)];
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = 1;
    contentView.font = [UIFont systemFontOfSize:15];
    contentView.text = _leftRecordInfo.content;
    _contentView = contentView;
    [self.view addSubview:contentView];
    
    // 底部
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame) + 8, kMainWidth, 105)];
    footView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    footView.layer.borderWidth = 1;
    
    UILabel *addPicture = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainWidth - 10, 29)];
    addPicture.text = @"添加图片";
    addPicture.textColor = [UIColor blackColor];
    [footView addSubview:addPicture];
    
    //  UIScrollView
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 31, kMainWidth, 74)];
    [footView addSubview:scrollview];
    _scrollview = scrollview;
    // 分割线
    UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kMainWidth, 1)];
    separateLine.backgroundColor = [UIColor lightGrayColor];
    [footView addSubview:separateLine];
    
    // 添加图片按钮
    UIButton *addPictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 65, 65)];
    [addPictureBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [scrollview addSubview:addPictureBtn];
    _addPictureBtn = addPictureBtn;
    [addPictureBtn addTarget:self action:@selector(addPictures) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footView];
    // 图片
    NSMutableArray *imagesA = [NSMutableArray array];
    _imagesA = imagesA;
    for (NSInteger i = 0; i < _leftRecordInfo.image.count; i++) {
        NSString *imageURL = _leftRecordInfo.image[i];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        [_imagesA addObject:image];
        
        // 展示图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (75 * i), 5, 65, 65)];
        [_scrollview addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        _imageView = imageView;
    }
    _addPictureBtn.x_wcr = CGRectGetMaxX(_imageView.frame) + 10;
    _scrollview.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame) + 90, 0) ;
}
// 取消按钮
- (void)backLeftNavItemAction{
    [_topView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
// 添加图片
- (void)addPictures{
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = _leftRecordInfo.image.count + 3;
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [weakSelf.assets addObjectsFromArray:assets];
        for (NSInteger i = _leftRecordInfo.image.count; i < weakSelf.assets.count +_leftRecordInfo.image.count ; i++ ) {
            NSInteger j = i - _leftRecordInfo.image.count;
            MLSelectPhotoAssets *asset = weakSelf.assets[j];
            // 判断类型来获取Image
            UIImage *img = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            [_imagesA addObject:img];
            // 展示图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (75 * i), 5, 65, 65)];
            _imageView = imageView;
            [_scrollview addSubview:imageView];
            imageView.image = img;
            _imageView = imageView;
        }
        _addPictureBtn.x_wcr = CGRectGetMaxX(_imageView.frame) + 10;
        _scrollview.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame) + 90, 0) ;
        
    };
}

// 保存按钮
- (void)saveLeftRecord{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    LoginResponseAccount *account = [LoginResponseAccount decode];
    args[@"patientId"] = account.Id;
    if (_titleField.text.length && _contentView.text.length) {
        args[@"title"] = _titleField.text;
        args[@"content"] = _contentView.text;
        args[@"logId"] = _leftRecordInfo.ID;
        [httpUtil doUpImageRequest:@"api/medicalApiController/addLifeLog" images:_imagesA name:@"file" args:args response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                // 跳转回日志列表界面
                [self.navigationController popViewControllerAnimated:YES];
                [_topView removeFromSuperview];
            }
        }];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"标题和内容不能为空";
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
}


@end
