//
//  HLTNewCordController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/28.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTNewCordController.h"
#import "HLTSeeCardController.h"
#import "HLTSeeCordCell.h"
#import "HLTNewCardCell.h"
#import "HLTMRecordModel.h"
#import "HLTDepartModel.h"
#import "HLTDepartTwoModel.h"
//选择图片
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"

@interface HLTNewCordController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *firstText;

@property (nonatomic, strong) LoginResponseAccount *account;//修改前

@property (nonatomic, strong) SAMTextView *doctorTextview;
@property (nonatomic, strong) SAMTextView *medicaTextview;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIDatePicker *datePicker;//时间选择器
@property (nonatomic, strong) UIDatePicker *datePicker2;
@property (nonatomic, strong) NSString *titleString;//弹框文字

@property (nonatomic, strong) NSMutableArray *departOneArray;//一级科室数组
@property (nonatomic, strong) NSMutableArray *departTwoArray;//二级科室数组
@property (nonatomic, strong) UIScrollView *departTwoScroll;//二级科室scrollview
@property (nonatomic, strong) UIButton *departOneButton;//一级科室选择按钮
@property (nonatomic, strong) UIButton *departTwoButton;//二级科室选择按钮


@property (nonatomic, strong) UIScrollView *addScroll;//添加图片滚动视图
@property (nonatomic, strong) UIButton *addPictureBtn;//添加图片按钮
@property (nonatomic, strong) UIImageView *imageView;//添加的图片
@property (nonatomic, strong) UIImageView *seeImageview;//从浏览传来的图片
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic,strong)  NSMutableArray *imagesA;//添加的图片数组
@property (nonatomic, strong) NSMutableArray *imagesB;

@property (nonatomic) BOOL isTitle;
@property (nonatomic) BOOL isName;
@property (nonatomic) BOOL isGender;
@property (nonatomic) BOOL isBirthday;
@property (nonatomic) BOOL isDepartment;
@property (nonatomic) BOOL isSeeDoctor;
@property (nonatomic) BOOL isDatePicker;


@end

@implementation HLTNewCordController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"患者信息";
    _imagesA = [[NSMutableArray alloc] init];
    _imagesB = [[NSMutableArray alloc] init];
    [self addLeftBackItem];
    [self addRightButton];
    [self setNavigationBarProperty];
    [self requestPatientData];
    [self requestDepartmentData];
    [self addTableview];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - 请求患者数据
-(void)requestPatientData
{
     _afterCordModel = [[HLTMRecordModel alloc]init];
    
    if (_isNewTurn) {
        _account = [LoginResponseAccount decode];
        _afterCordModel.patientId = _account.Id;
        _afterCordModel.mhName = _account.patientName;
        _afterCordModel.gender = _account.gender;
        _afterCordModel.birthday2 = _account.birthday;
    }else
    {
        _afterCordModel = _cordModel;
    }
    
}


#pragma mark - 请求科室数据
-(void)requestDepartmentData
{
    __weak typeof (self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/findFirstDepartments" args:nil targetVC:self response:^(ResponseModel *responseMd)
     {
         if (responseMd.isResultOk) {
             weakSelf.departOneArray = [HLTDepartModel mj_objectArrayWithKeyValuesArray:responseMd.response];
         }
     }];
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
    args[@"patientId"] = _afterCordModel.patientId;
    args[@"mhTitle"] = _afterCordModel.mhTitle;
    args[@"mhName"] = _afterCordModel.mhName;
    args[@"gender"] = _afterCordModel.gender;
    args[@"birthday"] = _afterCordModel.birthday2;
    args[@"departmentName"] = _afterCordModel.departmentsName;
    args[@"seeadoctorDate"] = _afterCordModel.seeadoctorDate2;
    args[@"diagnose"] = _afterCordModel.diagnose;
    args[@"description"] = _afterCordModel.Description;
    if (_isNewTurn) {
       args[@"medicalId"] = @"";
    }else{
         args[@"medicalId"] = _afterCordModel.ID;
    }
    //3f4be774b0644aec915fff36b082ff14
    NSLog(@"args========%@",args);
    if (_isSeeTurn) {
        [httpUtil doUpImageRequest:@"api/medicalApiController/addMedicalHistory" images:_imagesB name:@"file" args:args response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self isSuccess:@"添加病历成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self isSuccess:@"添加病历失败"];
            }
        }];
    }else{
        [httpUtil doUpImageRequest:@"api/medicalApiController/addMedicalHistory" images:_imagesA name:@"file" args:args response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self isSuccess:@"添加病历成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self isSuccess:@"添加病历失败"];
            }
        }];
    }
    
}

-(void)addTableview
{
    TPKeyboardAvoidingScrollView * scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    [self.view addSubview:scrollView];
    
    _firstText = @[@"病历标题",@"姓名",@"性别",@"出生日期",@"科室",@"就诊时间"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, kMainHeight-KTopLayoutGuideHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kBackgroundColor;
    [scrollView addSubview:_tableView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else
        return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 5;
    }else
        return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section ==1){
        return 130;
    }else
        return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _firstText.count;
    }else{
        return 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat xPoint = AUTO_MATE_WIDTH(15);
    CGFloat yPoint = AUTO_MATE_HEIGHT(10);
    CGFloat width = kMainWidth-xPoint * 2;
    CGFloat height = AUTO_MATE_HEIGHT(80);
    
    if (indexPath.section == 0) {
        HLTNewCardCell * newCell = [[HLTNewCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seeCell"];
        newCell.textString = _firstText[indexPath.row];
        //newCell.account = _account;
        newCell.cordModel = _afterCordModel;
        if (indexPath.row == 0) {
           [newCell.textField addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
        }else if (indexPath.row == 1){
            [newCell.textField addTarget:self action:@selector(textFieldDidChange2:) forControlEvents:UIControlEventEditingChanged];
        }
        
        return newCell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
        label.text = @"医生诊断";
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        
        _doctorTextview = [[SAMTextView alloc] initWithFrame:CGRectMake(xPoint, label.maxY_wcr+5, width, height+yPoint)];
        _doctorTextview.placeholder = @"医生诊断，比如疾病名称";
        _doctorTextview.font = [UIFont systemFontOfSize:15];
        _doctorTextview.layer.borderColor = KLineColor.CGColor;
        _doctorTextview.layer.borderWidth = 1;
        _doctorTextview.delegate =self;
        if (_isSeeTurn) {            
            _doctorTextview.text = _afterCordModel.diagnose;
        }
        [cell.contentView addSubview:_doctorTextview];
        return cell;
        
    }else if (indexPath.section ==2){
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
        label.text = @"基本病情";
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        
        _medicaTextview = [[SAMTextView alloc] initWithFrame:CGRectMake(xPoint, label.maxY_wcr+5, width, height+xPoint+yPoint)];
        _medicaTextview.placeholder = @"尽量包含以下内容\n(1)起病情况与时间\n(2)主要的症状:部位、性质、持续时间和程度\n(3)就医情况与处理\n";
        _medicaTextview.font = [UIFont systemFontOfSize:14];
        _medicaTextview.layer.borderColor = KLineColor.CGColor;
        _medicaTextview.layer.borderWidth = 1;
        _medicaTextview.delegate = self;
        if (_isSeeTurn) {
            
            _medicaTextview.text = _afterCordModel.Description;
        }
        [cell.contentView addSubview:_medicaTextview];
        
        return cell;
    }else{
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
        label.text = @"上传检查报告和处方单图片";
        label.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:label];
        
        height =AUTO_MATE_HEIGHT(130)-label.maxY_wcr;
        
        //  UIScrollView
        _addScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(xPoint, label.maxY_wcr+xPoint, kMainWidth-xPoint*2, height)];
        [cell.contentView addSubview:_addScroll];
        
        if (_isSeeTurn) {
            
            CGFloat height = AUTO_MATE_HEIGHT(130)-AUTO_MATE_HEIGHT(45);
            CGFloat yPoint = AUTO_MATE_HEIGHT(6);
            for (int i = 0; i<_afterCordModel.image.count; i++) {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((height+10)*i, yPoint, height, height)];
                [_imageView sd_setImageWithURL:[NSURL URLWithString:_afterCordModel.image[i]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
                [_addScroll addSubview:_imageView];
                [_imagesA addObject:_afterCordModel.image[i]];
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_afterCordModel.image[i]]] scale:0];
                [_imagesB addObject:image];
            }
            
            //_addPictureBtn.x_wcr = CGRectGetMaxX(_imageView.frame) + 10;
            _addScroll.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame) + 120, 0) ;
            
            // 添加图片按钮
            _addPictureBtn= [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 10, yPoint, height, height)];
            [_addPictureBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [_addScroll addSubview:_addPictureBtn];
            [_addPictureBtn addTarget:self action:@selector(addPictures) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
            // 添加图片按钮
            yPoint = AUTO_MATE_HEIGHT(6);
            height = height-AUTO_MATE_HEIGHT(15);
            UIButton *addPictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(yPoint, yPoint, height, height)];
            [addPictureBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            [_addScroll addSubview:addPictureBtn];
            _addPictureBtn = addPictureBtn;
            [addPictureBtn addTarget:self action:@selector(addPictures) forControlEvents:UIControlEventTouchUpInside];
            
        }
        return cell;
    }
}

#pragma mark - 添加图片点击事件
-(void)addPictures
{
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 15;
    
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [weakSelf.assets addObjectsFromArray:assets];
        
        CGFloat height = AUTO_MATE_HEIGHT(130)-AUTO_MATE_HEIGHT(45);
        CGFloat yPoint = AUTO_MATE_HEIGHT(6);
        
        if (_isSeeTurn) {
            for (NSInteger i = _afterCordModel.image.count; i < weakSelf.assets.count+_afterCordModel.image.count; i++ ) {
                MLSelectPhotoAssets *asset = weakSelf.assets[i-_afterCordModel.image.count];
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
            _addScroll.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame) + 120, 0) ;
            
            
            
            
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
            _addScroll.contentSize = CGSizeMake(CGRectGetMaxX(_imageView.frame) + 120, 0) ;
            
        }
        _afterCordModel.image = _imagesA;
        
    };
}

- (NSMutableArray *)assets{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

#pragma mark - cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HLTNewCardCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.textlabel.text isEqualToString:@"病历标题"]) {
            cell.textField.enabled= YES;
        }else if ([cell.textlabel.text isEqualToString:@"姓名"]){
            cell.textField.enabled= YES;
        }else if ([cell.textlabel.text isEqualToString:@"性别"]){
            _isGender = YES;
            _isBirthday = NO;
            _isDepartment = NO;
            _isSeeDoctor = NO;

            NSIndexPath *indexPath0=[NSIndexPath indexPathForRow:0 inSection:0];
            HLTNewCardCell *cell0 = [self.tableView cellForRowAtIndexPath:indexPath0];
            [cell0.textField resignFirstResponder];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            HLTNewCardCell *cell1 = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell1.textField resignFirstResponder];
            [self setPopViewWithTitle:@"性别"];
            
        }else if ([cell.textlabel.text isEqualToString:@"出生日期"]){
            _isGender = NO;
            _isBirthday = YES;
            _isDepartment = NO;
            _isSeeDoctor = NO;
            NSIndexPath *indexPath0=[NSIndexPath indexPathForRow:0 inSection:0];
            HLTNewCardCell *cell0 = [self.tableView cellForRowAtIndexPath:indexPath0];
            [cell0.textField resignFirstResponder];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            HLTNewCardCell *cell1 = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell1.textField resignFirstResponder];
            [self setPopViewWithTitle:@"出生日期"];
            
        }else if ([cell.textlabel.text isEqualToString:@"科室"]){
            _isGender = NO;
            _isBirthday = NO;
            _isDepartment = YES;
            _isSeeDoctor = NO;
            NSIndexPath *indexPath0=[NSIndexPath indexPathForRow:0 inSection:0];
            HLTNewCardCell *cell0 = [self.tableView cellForRowAtIndexPath:indexPath0];
            [cell0.textField resignFirstResponder];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            HLTNewCardCell *cell1 = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell1.textField resignFirstResponder];
            [self setPopViewWithTitle:@"科室"];
            
        }else if ([cell.textlabel.text isEqualToString:@"就诊时间"]){
            _isGender = NO;
            _isBirthday = NO;
            _isDepartment = NO;
            _isSeeDoctor = YES;
            NSIndexPath *indexPath0=[NSIndexPath indexPathForRow:0 inSection:0];
            HLTNewCardCell *cell0 = [self.tableView cellForRowAtIndexPath:indexPath0];
            [cell0.textField resignFirstResponder];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            HLTNewCardCell *cell1 = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell1.textField resignFirstResponder];
            [self setPopViewWithTitle:@"就诊时间"];
            
        }
        [_tableView resignFirstResponder];
        [_doctorTextview resignFirstResponder];
        [_medicaTextview resignFirstResponder];
    }
}

#pragma mark - 监听 病历标题textfiled 变化
- (void) textFieldDidChange1:(UITextField *) textField{
    _afterCordModel.mhTitle = textField.text;
}

#pragma mark - 监听 姓名textfiled 变化
- (void) textFieldDidChange2:(UITextField *) textField{
    _afterCordModel.mhName = textField.text;
}


#pragma mark - 上弹窗口
-(void)setPopViewWithTitle:(NSString*)title {
    _titleString = title;
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
    UIButton *leftButton = [self setLeftAndRightButtonWithButtonTitle:@"取消" andTag:52 andXpoint:0.0f WithSuperView:contentView];
    
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
    [self setLeftAndRightButtonWithButtonTitle:@"完成" andTag:53 andXpoint:xPoint WithSuperView:contentView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, label.maxY_wcr - 1, kMainWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:line];
    
    height = contentView.height_wcr - label.height_wcr;
    yPoint = label.maxY_wcr - 10;
    
    if ([title isEqualToString:@"出生日期"]) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, yPoint, kMainWidth, height)];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        //设置中文显示
        datePicker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _datePicker = datePicker;
        
        [contentView addSubview:datePicker];
        
    }else if ([title isEqualToString:@"科室"]) {
        
        UIScrollView * depaScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPoint+5, kMainWidth*0.5, height)];
        
        for (int i = 0; i<_departOneArray.count; i++) {
            
            HLTDepartModel * depaModel = _departOneArray[i];
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*30+3, kMainWidth*0.5, 30)];
            button.tag = i;
            button.layer.borderColor = KLineColor.CGColor;
            button.layer.borderWidth = 1;
            [button setTitle:depaModel.departmentsName forState:0];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectedDepartOne:) forControlEvents:UIControlEventTouchUpInside];
            [depaScroll addSubview:button];
            
            depaScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + 40);
        }
        
        UIView *separationLine1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(depaScroll.frame), yPoint+7, 1, height)];
        separationLine1.backgroundColor = [UIColor lightGrayColor];
        [contentView addSubview:separationLine1];
        
        
        _departTwoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(separationLine1.maxX_wcr, yPoint+5, kMainWidth*0.5, height)];
        
        [contentView addSubview:depaScroll];
        [contentView addSubview:_departTwoScroll];
        
    }else if ([title isEqualToString:@"性别"]){
        
        UIScrollView * genderScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPoint+5, kMainWidth, height)];
        NSArray * genderArr = @[@"男",@"女"];
        
        for (int i = 0; i<2; i++) {
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*40+4, kMainWidth, 40)];
            [button setTitle:genderArr[i] forState:UIControlStateNormal];
            button.tag = 50+i;
            button.layer.borderColor = KLineColor.CGColor;
            button.layer.borderWidth = 1;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(genderButton:) forControlEvents:UIControlEventTouchUpInside];
            [genderScroll addSubview:button];
        }
        
        [contentView addSubview:genderScroll];
        
    }else if ([title isEqualToString:@"就诊时间"]){
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, yPoint, kMainWidth, height)];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        //设置中文显示
        datePicker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        _datePicker2 = datePicker;
        
        [contentView addSubview:datePicker];
    }
    
    [bgView addSubview:contentView];
    
    [UIView animateWithDuration:0.5f animations:^{
        contentView.y_wcr = kMainHeight - height;
    }];
}

#pragma mark - 一级科室选择按钮
-(void)selectedDepartOne:(UIButton *)departButton
{
    if(departButton!= _departOneButton){
        _departOneButton.selected=NO;
        _departOneButton=departButton;
    }
    _departOneButton.selected=YES;
    
    for (UIView *subView in _departTwoScroll.subviews) {
        [subView removeFromSuperview];
    }
    
    HLTDepartModel *departModel = _departOneArray[departButton.tag];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = departModel.ID;
    __weak typeof(self) weakSelf = self;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/findSecondDepartments" args:args targetVC:self response:^(ResponseModel *responseMd) {
        weakSelf.departTwoArray = [HLTDepartTwoModel mj_objectArrayWithKeyValuesArray:responseMd.response];
        
        for (int i =0; i<weakSelf.departTwoArray.count; i++) {
            HLTDepartTwoModel * depaModeltwo = _departTwoArray[i];
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*30+3, kMainWidth*0.5, 30)];
            button.tag = 50+i;
            button.layer.borderColor = KLineColor.CGColor;
            button.layer.borderWidth = 1;
            [button setTitle:depaModeltwo.departmentsName forState:0];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(selectedDepartTwo:) forControlEvents:UIControlEventTouchUpInside];
            _departTwoScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(button.frame) + 40);
            [_departTwoScroll addSubview:button];
        }
        
    }];
}

#pragma mark - 二级科室选择按钮
-(void)selectedDepartTwo:(UIButton *)deparTwoButton
{
    if(deparTwoButton!= _departTwoButton){
        _departTwoButton.selected=NO;
        _departTwoButton=deparTwoButton;
    }
    _departTwoButton.selected=YES;
    
    _afterCordModel.departmentsName = [NSString stringWithFormat:@"%@%@",_departOneButton.titleLabel.text,_departTwoButton.titleLabel.text];
    
    
}

#pragma mark - 性别选择按钮
-(void)genderButton:(UIButton *)button
{
    if(button!= _departTwoButton){
        _departTwoButton.selected=NO;
        _departTwoButton=button;
    }
    _departTwoButton.selected=YES;
    
    _afterCordModel.gender = button.titleLabel.text;
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
    if (button.tag == 52) {// 取消
        
    }else if (button.tag == 53) {//确定
        
        if (_isGender) {
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (_isBirthday){
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"YYYY-MM-dd";
            NSString *timestamp = [formatter stringFromDate:_datePicker.date];
            _afterCordModel.birthday2 = timestamp;
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (_isDepartment){
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }else if (_isSeeDoctor){
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"YYYY-MM-dd";
            NSString *timestamp = [formatter stringFromDate:_datePicker2.date];
            _afterCordModel.seeadoctorDate2 = timestamp;
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    }
    
    [_bgView removeFromSuperview];
}


-(void)changeValue:(NSNotification *)notification andTextField:(UITextView *)textView{
   textView.text = notification.object;
    _afterCordModel.Description = textView.text;
    //self.doctorTextview.text = textField.text;
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_tableView resignFirstResponder];
    [_doctorTextview resignFirstResponder];
    [_medicaTextview resignFirstResponder];
}

#pragma mark - 监听textView的变化
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (_doctorTextview == textView) {
        _afterCordModel.diagnose = _doctorTextview.text;
    }
    
    if(_medicaTextview == textView){
        _afterCordModel.Description = _medicaTextview.text;
    }
    
    return YES;
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
