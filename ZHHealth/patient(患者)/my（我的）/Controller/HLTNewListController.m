//
//  HLTNewListController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/30.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTNewListController.h"
#import "HLTNewCardCell.h"
//选择图片
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"

@interface HLTNewListController ()  <UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *remarkField;
@property (nonatomic, strong) UIScrollView *addScroll;
@property (nonatomic, strong) UIButton *addPictureBtn;
@property (nonatomic, strong) UIImageView *imageView;//添加的图片
@property (nonatomic, strong) NSMutableArray *assets;//图片数组
@property (nonatomic,strong)  NSMutableArray *imagesA;//添加的图片数组
@property (nonatomic, strong) NSMutableArray *imagesB;

@property (nonatomic, strong) UIView *bgView;//蒙版
@property (nonatomic, strong) UIDatePicker *datePicker;//时间选择器
@property (nonatomic, strong) UIButton *eventButton;//事件选择按钮
@property (nonatomic, strong) UIPickerView *eventPicker;//事件选择器
@property (nonatomic, strong) NSArray *eventArr;//事件选择器数组

@property (nonatomic) BOOL isEvent;
@property (nonatomic) BOOL isDate;
@property (nonatomic, strong) NSString *rowString;//picker的row

@end

@implementation HLTNewListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建病程";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _imagesA = [[NSMutableArray alloc] init];
    _imagesB = [[NSMutableArray alloc] init];
    if (_isCreateList) {
        _cdlistModel = [[cdList alloc] init];
    }
    [self addLeftBackItem];
    [self addRightButton];
    [self setNavigationBarProperty];
    [self addTableview];
    
}

#pragma mark - 右边提交按钮
-(void)addRightButton
{
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
}
//提交
-(void)rightButton
{
    
    NSMutableDictionary * args = [NSMutableDictionary dictionary];
    args[@"mhId"] = _cordModel.ID;
    args[@"cdDate"] = _cdlistModel.cdDate2;
    args[@"incident"] = _cdlistModel.incident;
    if (_isCreateList==YES) {
      args[@"diseaseId"] = @"";
    }else{
      args[@"diseaseId"] = _cdlistModel.ID;
    }
    args[@"remark"] = _cdlistModel.remark;
    //2e5778f5ce9a41689869aca429c4b6e4
    NSLog(@"args=%@",args);
    
    if (_isEditList) {
        [httpUtil doUpImageRequest:@"api/medicalApiController/addDisease" images:_imagesB name:@"file" args:args response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self isSuccess:@"添加病程成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self isSuccess:@"参数有错"];
            }
        }];
    }else{
        [httpUtil doUpImageRequest:@"api/medicalApiController/addDisease" images:_imagesA name:@"file" args:args response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self isSuccess:@"添加病程成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self isSuccess:@"参数有错"];
            }
        }];
    }
    
}

#pragma mark - 添加tableview
-(void)addTableview
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight+10, kMainWidth, kMainHeight-KTopLayoutGuideHeight-10) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = kBackgroundColor;
    _tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableview];
}


#pragma mark - tableview  section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 10;
    }else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 35;
    }else
        return AUTO_MATE_HEIGHT(80);
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else
        return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat xPoint = AUTO_MATE_WIDTH(15);
    CGFloat yPoint = AUTO_MATE_HEIGHT(10);
    CGFloat width = kMainWidth-xPoint * 2;
    CGFloat height = AUTO_MATE_HEIGHT(80);
    
    NSArray * textarr = @[@"日期",@"事件"];
    if (indexPath.section == 0) {
        
        HLTNewCardCell * cell = [[HLTNewCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textString = textarr[indexPath.row];
        cell.cdlistModel = _cdlistModel;
        return cell;
        
    }else if (indexPath.section == 1){
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _remarkField = [[UITextField alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height-xPoint)];
        _remarkField.placeholder = @"备注";
        _remarkField.font = [UIFont systemFontOfSize:15];
        _remarkField.layer.borderColor = KLineColor.CGColor;
        _remarkField.layer.borderWidth = 1;
        if (_isEditList) {
          _remarkField.text = _cdlistModel.remark;
        }
        _cdlistModel.remark = _remarkField.text;
        [_remarkField addTarget:self action:@selector(textField:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:_remarkField];
        return cell;
        
    }else{
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //  UIScrollView
        _addScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(xPoint, 0, kMainWidth-xPoint*2, height)];
        _addScroll.showsHorizontalScrollIndicator = NO;
        _addScroll.showsVerticalScrollIndicator = NO;
        [cell.contentView addSubview:_addScroll];
        
        
        if (_isEditList) {
            
            CGFloat height = AUTO_MATE_HEIGHT(80)-yPoint*2;
            for (int i = 0; i<_cdlistModel.image.count; i++) {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((height+10)*i, yPoint, height, height)];
                [_imageView sd_setImageWithURL:[NSURL URLWithString:_cdlistModel.image[i]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
                [_addScroll addSubview:_imageView];
                [_imagesA addObject:_cdlistModel.image[i]];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_cdlistModel.image[i]]] scale:0];
                [_imagesB addObject:image];
            }
            
            //_addPictureBtn.x_wcr = CGRectGetMaxX(_imageView.frame) + 10;
            _addScroll.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame) + 90, 0) ;
            
            // 添加图片按钮
            _addPictureBtn= [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 10, yPoint, height, height)];
            [_addPictureBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [_addScroll addSubview:_addPictureBtn];
            [_addPictureBtn addTarget:self action:@selector(addPictures) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
            // 添加图片按钮
            yPoint = AUTO_MATE_HEIGHT(10);
            height = height-AUTO_MATE_HEIGHT(20);
            UIButton *addPictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, yPoint, height, height)];
            [addPictureBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [_addScroll addSubview:addPictureBtn];
            _addPictureBtn = addPictureBtn;
            [addPictureBtn addTarget:self action:@selector(addPictures) forControlEvents:UIControlEventTouchUpInside];
            
        }
        return cell;
        
    }
}

#pragma mark - textfiled监听事件
-(void)textField:(UITextField *)textField
{
    _cdlistModel.remark = textField.text;
}

#pragma mark - 添加图片点击事件
-(void)addPictures
{
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 10;
    
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [weakSelf.assets addObjectsFromArray:assets];
        
        CGFloat height = AUTO_MATE_HEIGHT(80)-AUTO_MATE_HEIGHT(20);
        CGFloat yPoint = AUTO_MATE_HEIGHT(10);
        
        if (_isEditList) {
            
            for (NSInteger i = _cdlistModel.image.count; i < weakSelf.assets.count+_cdlistModel.image.count; i++ ) {
                MLSelectPhotoAssets *asset = weakSelf.assets[i-_cdlistModel.image.count];
                // 判断类型来获取Image
                UIImage *img = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                [_imagesA addObject:img];
                // 展示图片
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(( height+10) * i, yPoint, height, height)];
                [_addScroll addSubview:_imageView];
                _imageView.image = img;
                [_imagesB addObject:img];
            }
            _addPictureBtn.x_wcr = CGRectGetMaxX(_imageView.frame) + 10;
            _addScroll.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame) + 90, 0) ;
            
        }else{
            
            for (NSInteger i = 0; i < weakSelf.assets.count; i++ ) {
                MLSelectPhotoAssets *asset = weakSelf.assets[i];
                // 判断类型来获取Image
                UIImage *img = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                [_imagesA addObject:img];
                // 展示图片
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((height+10) * i, yPoint, height, height)];
                [_addScroll addSubview:_imageView];
                _imageView.image = img;
            }
            _addPictureBtn.x_wcr = CGRectGetMaxX(_imageView.frame) + 10;
            _addScroll.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame) + 90, 0) ;
            
        }
        
        if (_isCreateList) {
            _cdlistModel.image = _imagesA;
        }
        
    };
}
- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

#pragma mark - cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSIndexPath *indexPath = [self.tableview indexPathForSelectedRow];
        HLTNewCardCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
        
        if ([cell.textlabel.text isEqualToString:@"日期"]) {
            _isDate = YES;
            _isEvent = NO;
            [self setPopViewWithTitle:@"日期"];
        }else{
            _isDate = NO;
            _isEvent = YES;
            [self setPopViewWithTitle:@"事件"];
        }
        
    }
    [_tableview resignFirstResponder];
    [_remarkField resignFirstResponder];
    
}


#pragma mark - 上弹窗口
-(void)setPopViewWithTitle:(NSString*)title {
   // _titleString = title;
    //蒙版
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:bgView];
    _bgView = bgView;
    
    //手势
    UITapGestureRecognizer *tapCancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCancelBgView)];
    [bgView addGestureRecognizer:tapCancel];
    
    CGFloat height = AUTO_MATE_HEIGHT(300);
    CGFloat yPoint = kMainHeight;
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0.0, yPoint, kMainWidth, height)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    // 取消按钮
    UIButton *leftButton = [self setLeftAndRightButtonWithButtonTitle:@"取消" andTag:37 andXpoint:0.0f WithSuperView:contentView];
    
    CGFloat xPoint = leftButton.maxX_wcr;
    CGFloat width = kMainWidth - xPoint * 2;
    height = AUTO_MATE_HEIGHT(40.0);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(xPoint, 0.0, width, height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"选择%@",title];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    
    //完成按钮
    xPoint = label.maxX_wcr;
    [self setLeftAndRightButtonWithButtonTitle:@"完成" andTag:38 andXpoint:xPoint WithSuperView:contentView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, label.maxY_wcr - 1, kMainWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:line];
    
    height = contentView.height_wcr - label.height_wcr;
    yPoint = label.maxY_wcr - 10;
    
    if ([title isEqualToString:@"日期"]) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, yPoint, kMainWidth, height)];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        //设置中文显示
        datePicker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _datePicker = datePicker;
        [contentView addSubview:datePicker];
        
    }else{
       
        _eventArr = @[@"首诊",@"复诊",@"入院",@"出院",@"手术",@"影像",@"化验",@"体征",@"病历",@"处方医嘱"];
        _eventPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, yPoint, kMainWidth, height)];
        _eventPicker.delegate = self;
        _eventPicker.dataSource = self;
        [contentView addSubview:_eventPicker];
        
    }
    [bgView addSubview:contentView];
    
    [UIView animateWithDuration:0.5f animations:^{
        contentView.y_wcr = kMainHeight - height;
    }];
}

#pragma mark - UIPicker delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _eventArr.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return AUTO_MATE_WIDTH(100);
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_eventArr objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _rowString = [_eventArr objectAtIndex:row];
    
}

#pragma mark - 取消完成按钮
-(UIButton*)setLeftAndRightButtonWithButtonTitle:(NSString*)buttonTittle andTag:(int)buttonTag andXpoint:(CGFloat)xPoint WithSuperView:(UIView*)superView {
    
    CGFloat width = AUTO_MATE_WIDTH(100);
    CGFloat height = AUTO_MATE_HEIGHT(40);
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(xPoint, 0, width, height)];
    [button setTitle:buttonTittle forState:0];
    [button setTitleColor:[UIColor blueColor] forState:0];
    button.tag = buttonTag;
    [button addTarget:self action:@selector(dateButtonAction:)];
    
    [superView addSubview:button];
    
    return button;
}

#pragma mark - 取消、确定按钮
-(void)dateButtonAction:(UIButton*)button {
    if (button.tag == 37) {// 取消
        
    }else if (button.tag == 38) {//确定
       
        if (_isDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"YYYY-MM-dd";
            NSString *timestamp = [formatter stringFromDate:_datePicker.date];
            _cdlistModel.cdDate2 = timestamp;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (_isEvent){
            _cdlistModel.incident = _rowString;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    
    [_bgView removeFromSuperview];
}

-(void)tapCancelBgView {
    [_bgView removeFromSuperview];
}


// 提示框-创建成功
- (void)isSuccess:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
