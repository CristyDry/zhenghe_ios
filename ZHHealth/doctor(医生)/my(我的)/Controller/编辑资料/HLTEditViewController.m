//
//  HLTEditViewController.m
//  ZHHealth
//
//  Created by ZhouZhenFu on 15/12/15.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "HLTEditViewController.h"
#import "HLTLabel.h"
#import "Tools.h"

#import "HLTProfessViewController.h"
#import "HLTIntroViewController.h"

#import "WcrReModifyPasController.h"
#import "WcrModifyPasswViewController.h"

@interface HLTEditViewController ()  <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HLTProfessViewControllerDelegate,HLTIntroViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView * iconImage;

@property (nonatomic, strong) UIView * doctorimage ;//医生资料
@property (nonatomic, strong) UIView *passimage;//修改密码
@property (nonatomic, strong) UIAlertView *alertView;//提示框

@property (nonatomic, assign) CGFloat height1;
@property (nonatomic, assign) CGFloat height2;
@property (nonatomic, strong) UIActionSheet *actionSheet;//底部菜单
@end

@implementation HLTEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加左边返回按钮
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    //添加界面
    [self addAllUI];
    
}

#pragma mark - 界面
-(void)addAllUI
{
    CGFloat width = kMainWidth;
    CGFloat height = AUTO_MATE_HEIGHT(70);
    CGFloat xPoint = AUTO_MATE_HEIGHT(10.0);
    CGFloat yPoint = 20.0;
    //医生资料
    _doctorimage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _doctorimage.backgroundColor = [UIColor whiteColor];
    _doctorimage.userInteractionEnabled = YES;
    
    [self addImageview:_doctorimage andHeight:height];
    [self.view addSubview:_doctorimage];
    //
    UILabel * iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(yPoint, 0, 90, height)];
    iconLabel.text = @"头       像";
    iconLabel.font = [UIFont systemFontOfSize:18];
    [_doctorimage addSubview:iconLabel];
    //头像
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(width-xPoint-(height-xPoint)-xPoint*2, xPoint, height-xPoint*2, height-xPoint*2)];
    _iconImage.layer.cornerRadius = (height-xPoint*2)*0.5;
    _iconImage.clipsToBounds = YES;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_editModel.avatar] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    [_doctorimage addSubview:_iconImage];
    [self addButton:_doctorimage andTag:300];
    //添加tableview
    [self addtableview];
}

-(void)addtableview
{
    CGFloat height = kMainHeight-KTopLayoutGuideHeight;
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KTopLayoutGuideHeight, kMainWidth, height) style:UITableViewStylePlain];
    _tableview.backgroundColor = kBackgroundColor;
    _tableview.tableHeaderView = _doctorimage;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 110;
        }else if (indexPath.row == 1){
            return _height1+20;
        }
        return _height2+20;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 90.0;
    CGFloat height = 30.0;
    CGFloat xPoint = 20.0;
    CGFloat yPoint = 10.0;
    
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == 0) {
            
            NSString * cellId = @"doctor";
            UITableViewCell * editCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
            label.text = @"基本资料";
            label.font = [UIFont systemFontOfSize:18];
            [editCell.contentView addSubview:label];
            //名字
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.maxX_wcr , yPoint, 100, 25)];
            nameLabel.text = _editModel.doctor;
            nameLabel.font = [UIFont systemFontOfSize:18];
            [editCell.contentView addSubview:nameLabel];
            //科目
            UILabel * departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.maxX_wcr , nameLabel.maxY_wcr +10, 50, 15)];
            departmentLabel.text = _editModel.department;
            departmentLabel.textColor = [UIColor lightGrayColor];
            [editCell.contentView addSubview:departmentLabel];
            //医师
            UILabel *professionalLabel = [[UILabel alloc] initWithFrame:CGRectMake(departmentLabel.maxX_wcr +3, nameLabel.maxY_wcr+10, 100, 15)];
            professionalLabel.text = _editModel.professional;
            professionalLabel.textColor = [UIColor lightGrayColor];
            [editCell.contentView addSubview:professionalLabel];
            //医院
            UILabel * hospitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.maxX_wcr , professionalLabel.maxY_wcr+10, kMainWidth - label.maxX_wcr-xPoint-30, 15)];
            hospitalLabel.text = _editModel.hospital;
            hospitalLabel.textColor = [UIColor lightGrayColor];
            editCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [editCell.contentView addSubview:hospitalLabel];

            return editCell;
            
        }else if (indexPath.row == 1)
        {
            NSString * cellId = @"profess";
            UITableViewCell * editCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            //titlelabel
            UILabel * proLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
            proLabel.text = @"专业领域";
            proLabel.font = [UIFont systemFontOfSize:18];
            [editCell.contentView addSubview:proLabel];
            //内容
            _height1 =[Tools calculateLabelHeight:_editModel.professionalField font:[UIFont systemFontOfSize:15] AndWidth: kMainWidth-xPoint*2-width-20];
            
            UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(proLabel.maxX_wcr ,yPoint, kMainWidth-xPoint*2-width-20, _height1)];
            contentLabel.text = _editModel.professionalField;
            contentLabel.font = [UIFont systemFontOfSize:15];
            contentLabel.textColor = [UIColor grayColor];
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode =NSLineBreakByWordWrapping;
            editCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [editCell.contentView addSubview:contentLabel];
            
             return editCell;
            
        }else
        {
            NSString * cellId = @"intro";
            UITableViewCell * editCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            //titlelabel
            UILabel * proLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, xPoint)];
            proLabel.text = @"个人简介";
            proLabel.font = [UIFont systemFontOfSize:18];
            [editCell.contentView addSubview:proLabel];
            //内容
            _height2 =[Tools calculateLabelHeight:_editModel.intro font:[UIFont systemFontOfSize:15] AndWidth: kMainWidth-xPoint*2-width-20];
            
            UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(proLabel.maxX_wcr , yPoint,  kMainWidth-xPoint*2-width-20, _height2)];
            contentLabel.text = _editModel.intro;
            contentLabel.font = [UIFont systemFontOfSize:15];
            contentLabel.textColor = [UIColor grayColor];
            contentLabel.numberOfLines = 0;
            contentLabel.lineBreakMode =NSLineBreakByWordWrapping;
            editCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [editCell.contentView addSubview:contentLabel];
           
            return editCell;
        }
       
        
    }else{
        
        UITableViewCell * passCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"passId"];
        //密码
        UILabel * passLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, yPoint, width, height)];
        passLabel.text = @"修改密码";
        passLabel.font = [UIFont systemFontOfSize:18];
        passLabel.textAlignment = NSTextAlignmentLeft;
        [passCell.contentView addSubview:passLabel];
        passCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return passCell;
    }
}

#pragma mark - cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row)
        {
            case 0:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"需修改医院信息请拨打电话与客服联系" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSLog(@"拨打客服电话");
                    UIWebView *callWebview =[[UIWebView alloc] init];
                    NSURL *telURL =[NSURL URLWithString:@"tel:400-123-123"];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                    [self.view addSubview:callWebview];
                    
                }];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
                break;
            case 1:
            {
                HLTProfessViewController * proVC = [[HLTProfessViewController alloc] init];
                proVC.editmodel = _editModel;
                proVC.delegate =self;
                [self.navigationController pushViewController:proVC animated:YES];
            }
                break;
            case 2:
            {
                HLTIntroViewController * intro = [[HLTIntroViewController alloc] init];
                intro.editmodel = _editModel;
                intro.delegate =self;
                [self.navigationController pushViewController:intro animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        NSLog(@"修改密码");
        WcrModifyPasswViewController * Modify = [[WcrModifyPasswViewController alloc] init];
        [self.navigationController pushViewController:Modify animated:YES];
    }

}

#pragma mark - 添加buttonview
-(void)addImageview:(UIView *)imageview andHeight:(CGFloat)height
{
    UIImageView * buttonView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainWidth-25, (height-14)*0.5, 9, 14)];
    buttonView.image = [UIImage imageNamed:@"后退-拷贝"];
    [imageview addSubview:buttonView];
    
}


#pragma mark - 添加button
-(void)addButton:(UIView *)view andTag:(NSInteger)tag
{
    UIButton * button = [[UIButton alloc] initWithFrame:view.frame];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}

#pragma mark - 点击事件
-(void)buttonClick:(UIButton *)button
{
    switch (button.tag-300) {
        case 0:
        {
            NSLog(@"头像");
            _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            [_actionSheet showInView:self.view];
        }
            break;
        default:
            break;
    }
}

#pragma mark - actionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"拍照");
        [self loadPickerWithType:UIImagePickerControllerSourceTypeCamera];
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"手机相册选择");
        [self loadPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
        
}

#pragma mark - 拍照或选择图片
-(void)loadPickerWithType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    
    picker.allowsEditing = YES;
    
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - choose执行方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    HLTLoginResponseAccount *account = [HLTLoginResponseAccount decode];
    args[@"id"] = account.Id;
    
    [httpUtil doUpImageRequest:@"api/ZhengheDoctor/uploadAvatar" Image:image name:@"file" args:args response:^(ResponseModel *responseMd) {
            if (responseMd.isResultOk) {
                [self isStatus:@"修改成功"];
                _iconImage.image = image;
                account.avatar = [responseMd.response objectForKey:@"avatar"];
                [HLTLoginResponseAccount encode:account];
                //返回编辑页面
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
}

#pragma mark - profess delegate
-(void)changeProfess:(HLTEditModel *)afterModel
{
    _editModel = afterModel;
    [_tableview reloadData];
}
#pragma mark - intro delegate
-(void)changeIntro:(HLTEditModel *)afterModel
{
    _editModel = afterModel;
    [_tableview reloadData];
}

#pragma mark - 点击取消执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //返回编辑页面
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)isStatus:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
