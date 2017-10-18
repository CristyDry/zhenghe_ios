//
//  MyPrescriptionViewController.m
//  ZHHealth
//
//  Created by GaoLiang on 2017/10/10.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import "MyPrescriptionViewController.h"
#import "HLTPrescriptionHistoryViewControllerViewController.h"
#import "ShoppingCountView.h"

@interface MyPrescriptionViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    __weak IBOutlet UITableView *PrescriptionTableview;
    __weak IBOutlet UILabel *shopNameLable;
    __weak IBOutlet UITextField *patinetNameTF;
    __weak IBOutlet UIButton *ManSelBtn;
    __weak IBOutlet UIButton *WomanSelBtn;
    __weak IBOutlet UITextField *patiientAgeTF;
    __weak IBOutlet UITextField *patientPhoneTF;
    __weak IBOutlet UITextView *diagnosisTextView;
    __weak IBOutlet UITextField *diagnosisTipLable;
    __weak IBOutlet UILabel *SumCountLable;
    NSMutableArray *myDrugsArray;
    // 弹框view
    __weak IBOutlet UIView *SelectView;
    // 店铺弹框
    __weak IBOutlet UIView *SelectShopView;
    __weak IBOutlet UITableView *SelectShopTableview;
    NSArray *drugShopArr;
    NSString *drugShopAreaStr;
    NSString *departmentIdStr;
    NSMutableArray *delegateArray;
    // 药品弹框
    __weak IBOutlet UIView *SelectDrugView;
    __weak IBOutlet UITextView *SearchTextView;
    __weak IBOutlet UITableView *drugTableview;
    NSArray *drugGoodsArr;
    NSString *keyStr;
    // 使用说明弹框
    __weak IBOutlet UIView *InstrutionView;
    __weak IBOutlet UITextView *instrutionTextView;
    __weak IBOutlet UILabel *instrutionTipLable;
    NSString *instrutionInputStr;
    NSInteger currentIndexPathRow;
    
    NSString *tabelviewType;    // 0 处方信息的药品   1 店铺药店    2 店铺的药
}
@end

@implementation MyPrescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处方信息";
    PrescriptionTableview.dataSource = self;
    PrescriptionTableview.delegate = self;
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    [self addRightButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setPrescriptionUI];
}

#pragma mark - 右边新建按钮
-(void)addRightButton
{
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rightBtn setTintColor:[UIColor whiteColor]];
    [rightBtn setImage:[UIImage imageNamed:@"三点"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(ClickPrescriptionHistory) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark UI 搭建
- (void)setPrescriptionUI {
    // 初始值
    tabelviewType = @"0";
    myDrugsArray = [NSMutableArray arrayWithCapacity:0];
    SearchTextView.delegate = self;
    SearchTextView.layer.borderWidth = 1.0f;
    SearchTextView.layer.cornerRadius = 5.0f;
    SearchTextView.layer.borderColor = UIColorFromHex(0xd7d7d7).CGColor;
    NSDictionary *seleceshopDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"drugShopDic"];
    if (seleceshopDic) {
        shopNameLable.text = seleceshopDic[@"name"];
        departmentIdStr = seleceshopDic[@"id"];
    } else {
        shopNameLable.text = @"请选中门店";
    }
    ManSelBtn.selected = YES;
    diagnosisTextView.delegate = self;
}
#pragma mark 数据的请求
- (void)requestSelectShop {
    // 药店列表
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [httpUtil doPostRequest:@"api/ZhengheRx/office" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            NSArray *resultArray = responseMd.response;
            drugShopAreaStr = resultArray[0][@"name"];
            drugShopArr = resultArray[0][@"childs"];
            [SelectShopTableview reloadData];
        }
    }];
}

- (void)requestSelectDrug {
    // 搜索药品
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"keys"] = keyStr;
    args[@"simple"] = @"true";
    args[@"pageNo"] = @"0";
    args[@"orderBy"] = @"2";
    args[@"pageSize"] = @"10";
    
    [httpUtil doPostRequest:@"api/ZhengheProduct/searchProduct" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            drugGoodsArr = responseMd.response;
            [drugTableview reloadData];
        }
    }];
    
}

- (void)requestCreateChuFangDrugMsg {
    // 创建处方
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    HLTLoginResponseAccount * account = [HLTLoginResponseAccount decode];
    args[@"clinicalDiagnosis"] = diagnosisTextView.text;
    args[@"creator"] = account.Id;
    args[@"departmentId"] = departmentIdStr;
    args[@"patientAge"] = patiientAgeTF.text;
    args[@"patientName"] = patinetNameTF.text;
    if (ManSelBtn.selected) {
        // 男
        args[@"patientGender"] = @"1";
    } else {
        args[@"patientGender"] = @"2";
    }
    args[@"patientPhone"] = patientPhoneTF.text;
    NSMutableArray *drugsArrM = [NSMutableArray new];
    for (NSDictionary *dic in myDrugsArray) {
        NSMutableDictionary *drugDicM = [NSMutableDictionary dictionary];
        [drugDicM setValue:dic[@"num"] forKey:@"num"];
        [drugDicM setValue:dic[@"id"] forKey:@"productId"];
        if ([[dic allKeys] containsObject:@"sig"]) {
            [drugDicM setValue:dic[@"sig"] forKey:@" sig"];
        } else {
            [drugDicM setValue:@"" forKey:@" sig"];
        }
        [drugsArrM addObject:drugDicM];
    }
    args[@"zhengheRxDetailList"] = drugsArrM;
    [httpUtil doPostRequest:@"api/ZhengheRx/create" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"处方提交成功" message:[NSString stringWithFormat:@"取药号：%@",responseMd.response[@"rxNo"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}
#pragma mark - 处方历史点击事件
-(void)ClickPrescriptionHistory
{
    HLTPrescriptionHistoryViewControllerViewController *presctiptionHistoryVc = [GetPrescriptionStoryboard instantiateViewControllerWithIdentifier:@"HLTPrescriptionHistoryViewControllerViewController"];
    [self.navigationController pushViewController:presctiptionHistoryVc animated:YES];
}
#pragma mark - Click Action
- (IBAction)ClickChooseCurrentShopAction:(UIButton *)sender {
    // 弹出店铺
    [SelectView bringSubviewToFront:self.view];
    tabelviewType = @"1";
    SelectShopTableview.dataSource = self;
    SelectShopTableview.delegate = self;
    delegateArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(putawayOrderListAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [delegateArray addObject:btn];
    }
    
    [self requestSelectShop];
    [UIView animateWithDuration:0.5 animations:^{
        SelectView.hidden = NO;
        SelectShopView.hidden = NO;
        SelectDrugView.hidden = YES;
        InstrutionView.hidden = YES;
    }];
}

- (IBAction)ClickSelectManAction:(UIButton *)sender {
    ManSelBtn.selected = YES;
    WomanSelBtn.selected = NO;
}

- (IBAction)ClickSelectWomanAction:(UIButton *)sender {
    ManSelBtn.selected = NO;
    WomanSelBtn.selected = YES;
}

- (IBAction)ClickAddDrugAction:(UIButton *)sender {
    // 弹出药品
    [SelectView bringSubviewToFront:self.view];
    tabelviewType = @"2";
    drugTableview.dataSource = self;
    drugTableview.delegate = self;
    keyStr = @"";
    [self requestSelectDrug];
    
    [UIView animateWithDuration:0.5 animations:^{
        SelectView.hidden = NO;
        SelectDrugView.hidden = NO;
        SelectShopView.hidden = YES;
        InstrutionView.hidden = YES;
    }];
    
}

- (IBAction)ClickSaveDrugsAction:(UIButton *)sender {
    if (patinetNameTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入病人名字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    if (patiientAgeTF.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入病人年龄" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    if (diagnosisTextView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入诊断信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    if (departmentIdStr.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择店铺" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    if (myDrugsArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择处方药" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return;
    }
    // 调用保存信息接口
    [self requestCreateChuFangDrugMsg];
}

- (IBAction)CilckDismissSelectShopDismissView:(UIButton *)sender {
    tabelviewType = @"0";
    [SelectView sendSubviewToBack:self.view];
    [UIView animateWithDuration:0.5 animations:^{
        SelectView.hidden = YES;
        SelectShopView.hidden = YES;
        SelectDrugView.hidden = YES;
        InstrutionView.hidden = YES;
    }];
}
- (IBAction)ClickDismissviewSelectDrugView:(UIButton*)sender {
    tabelviewType = @"0";
    [SelectView sendSubviewToBack:self.view];
    [PrescriptionTableview reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        SelectView.hidden = YES;
        SelectShopView.hidden = YES;
        SelectDrugView.hidden = YES;
        InstrutionView.hidden = YES;
    }];
}

- (void)ClickpopupInputTextAction:(UIButton*)sender {
    // 弹出输入使用说明的框
    instrutionTextView.delegate = self;
    [instrutionTextView becomeFirstResponder];
    currentIndexPathRow = [[sender titleForState:UIControlStateDisabled] integerValue];
    NSDictionary *myDrugDic = myDrugsArray[currentIndexPathRow];
    instrutionTextView.text = myDrugDic[@"sig"];
    [UIView animateWithDuration:0.5 animations:^{
        SelectView.hidden = NO;
        SelectShopView.hidden = YES;
        SelectDrugView.hidden = YES;
        InstrutionView.hidden = NO;
    }];
}

- (IBAction)ClickDismissInputCOntentAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        SelectView.hidden = YES;
        SelectShopView.hidden = YES;
        SelectDrugView.hidden = YES;
        InstrutionView.hidden = YES;
    }];
}

- (IBAction)ClickSaveInputContentAction:(UIButton *)sender {
    NSDictionary *myDrugDic = myDrugsArray[currentIndexPathRow];
    NSMutableDictionary * nDict = [NSMutableDictionary dictionaryWithDictionary:myDrugDic];
    [nDict setValue:[NSString stringWithFormat:@"%@",instrutionInputStr] forKey:@"sig"];
    //    [myDrugsArray removeObjectAtIndex:currentIndexPathRow];
    //    [myDrugsArray addObject:nDict];
    [myDrugsArray replaceObjectAtIndex:currentIndexPathRow withObject:nDict];
    
    [UIView animateWithDuration:0.5 animations:^{
        SelectView.hidden = YES;
        SelectShopView.hidden = YES;
        SelectDrugView.hidden = YES;
        InstrutionView.hidden = YES;
    }];
}

#pragma mark - UIDatasource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tabelviewType isEqualToString:@"0"]) {
        // 已选择的药品
        return myDrugsArray.count;
    } else if ([tabelviewType isEqualToString:@"1"]) {
        // 店
        UIButton *btn = delegateArray[section];
        if (btn.selected) {
            return 0;
        }
        return drugShopArr.count;
    } else if ([tabelviewType isEqualToString:@"2"]) {
        // 可选择的药品
        return drugGoodsArr.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *identifier;
    if ([tabelviewType isEqualToString:@"0"]) {
        // 已选择的药品
        identifier = @"DrugMessageCell";;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSDictionary *drugGoodsDic = myDrugsArray[indexPath.row];
        
        UIImageView *iconImage = [cell viewWithTag:8800];           // 药图片
        UILabel *drugName = [cell viewWithTag:8801];                // 药名字
        UILabel *price = [cell viewWithTag:8802];                   // 药价格
        UILabel *size = [cell viewWithTag:8803];                    // 药规格
        ShoppingCountView *shopCountView = [cell viewWithTag:8804]; // 药数量
        UIButton *instrutionBtn = [cell viewWithTag:8805];          // 药的使用说明
        
        [instrutionBtn setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateDisabled];                                // 保存其row值
        [instrutionBtn addTarget:self action:@selector(ClickpopupInputTextAction:)];
        shopCountView.amountTextField.text = drugGoodsDic[@"num"];
        float sunCount = 0.00;
        for (int i = 0; i < myDrugsArray.count ; i ++) {
            NSDictionary *dic = myDrugsArray[i];
            sunCount += ([dic[@"price"] floatValue] * [dic[@"num"] integerValue]);
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥%.2f",sunCount]];
        //设置文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, str.length - 3)];
        SumCountLable.attributedText = str;
        shopCountView.plusBlock = ^(NSInteger account, NSString *ID, UIButton *plusBtn, UIButton *minus, UITextField *amountTextField) {
            [self ChangeDrugNums:drugGoodsDic andShopTextF:amountTextField andIndexpath:(NSIndexPath *)indexPath];
        };
        
        shopCountView.minusBlock = ^(NSInteger account, NSString *ID, UIButton *plusBtn, UIButton *minus, UITextField *amountTextField) {
            if (account >= 1) {
                [self ChangeDrugNums:drugGoodsDic andShopTextF:amountTextField andIndexpath:(NSIndexPath *)indexPath];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要删除？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self ChangeDrugNums:drugGoodsDic andShopTextF:0 andIndexpath:(NSIndexPath *)indexPath];
                    
                }];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        };
        [iconImage sd_setImageWithURL:[NSURL URLWithString:drugGoodsDic[@"productPic"]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        drugName.text = [NSString stringWithFormat:@"%@",drugGoodsDic[@"productName"]];
        price.text = [NSString stringWithFormat:@"¥%@",drugGoodsDic[@"price"]];
        size.text = [NSString stringWithFormat:@"%@",drugGoodsDic[@"productUnit"]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if ([tabelviewType isEqualToString:@"1"]) {
        // 店
        identifier = @"DrugShopCell";;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSDictionary *drugShopDic = drugShopArr[indexPath.row];
        UILabel *drugShopLable = [cell viewWithTag:2200];
        drugShopLable.text = [NSString stringWithFormat:@"%@",drugShopDic[@"name"]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    } else if ([tabelviewType isEqualToString:@"2"]) {
        // 可选择的药品
        identifier = @"DrugsCell";;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSDictionary *drugGoodsDic = drugGoodsArr[indexPath.row];
        
        UIImageView *iconImage = [cell viewWithTag:3300];
        UILabel *drugName = [cell viewWithTag:3301];
        UILabel *price = [cell viewWithTag:3302];
        UILabel *size = [cell viewWithTag:3303];
        [iconImage sd_setImageWithURL:[NSURL URLWithString:drugGoodsDic[@"productPic"]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
        drugName.text = [NSString stringWithFormat:@"%@",drugGoodsDic[@"productName"]];
        price.text = [NSString stringWithFormat:@"¥%@",drugGoodsDic[@"price"]];
        size.text = [NSString stringWithFormat:@"%@",drugGoodsDic[@"productUnit"]];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, 50)];
    header.backgroundColor = RGBACOLOR(218, 218, 218, 0.82);
    // 增加点击收起的按钮
    UIButton *btn = delegateArray[section];
    [header addSubview:btn];
    [btn setFrame:CGRectMake(15, 8, 100, 30)];
    [btn setImage:[UIImage imageNamed:@"listOn"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"listOFF"] forState:UIControlStateSelected];
    if (drugShopAreaStr.length > 0) {
        [btn setTitle:drugShopAreaStr forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"南海区" forState:UIControlStateNormal];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:UIColorFromHex(0x5C5E66) forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tabelviewType isEqualToString:@"0"]) {
        // 已选择的药品
    } else if ([tabelviewType isEqualToString:@"1"]) {
        // 店
        return 60;
    } else if ([tabelviewType isEqualToString:@"2"]) {
        // 可选择的药品
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tabelviewType isEqualToString:@"0"]) {
        // 已选择的药品
        return 80;
    } else if ([tabelviewType isEqualToString:@"1"]) {
        // 店
        return 40;
    } else if ([tabelviewType isEqualToString:@"2"]) {
        // 可选择的药品
        return 60;
    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *selectDic;
    if ([tabelviewType isEqualToString:@"0"]) {
        // 已选择的药品
    } else if ([tabelviewType isEqualToString:@"1"]) {
        // 店
        selectDic = drugShopArr[indexPath.row];
        shopNameLable.text = [NSString stringWithFormat:@"%@",selectDic[@"name"]];
        drugShopAreaStr = selectDic[@"name"];
        departmentIdStr = [NSString stringWithFormat:@"%@",selectDic[@"id"]];
        // 保存选择的数据
        [[NSUserDefaults standardUserDefaults] setObject:selectDic forKey:@"drugShopDic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        tabelviewType = @"0";
        [SelectView sendSubviewToBack:self.view];
        [UIView animateWithDuration:0.5 animations:^{
            SelectView.hidden = YES;
            SelectShopView.hidden = YES;
            SelectDrugView.hidden = YES;
            InstrutionView.hidden = YES;
        }];
        
    } else if ([tabelviewType isEqualToString:@"2"]) {
        // 可选择的药品
        selectDic = drugGoodsArr[indexPath.row];
        NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:selectDic];
        if (myDrugsArray.count == 0) {
            [mDict setObject:@"1" forKey:@"num"];
            [myDrugsArray addObject:mDict];
        } else {
            BOOL isNewValue;
            isNewValue = YES;
            for (int i = 0; i < myDrugsArray.count; i++) {
                NSDictionary *dic = myDrugsArray[i];
                NSMutableDictionary * nDict = [NSMutableDictionary dictionaryWithDictionary:dic];
                if ([selectDic[@"id"] isEqualToString:nDict[@"id"]]) {
                    [nDict setValue:@"2" forKey:@"num"];
                    [myDrugsArray removeObjectAtIndex:i];
                    [myDrugsArray addObject:nDict];
                    isNewValue = NO;
                    break;
                }
            }
            if (isNewValue) {
                [mDict setObject:@"1" forKey:@"num"];
                [myDrugsArray addObject:mDict];
            }
        }
        [self requestSelectDrug];
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.tag == 9567) {
        if (textView.text.length > 0) {
            diagnosisTipLable.hidden = YES;
        } else {
            diagnosisTipLable.hidden = NO;
        }
        
    } else if (textView.tag == 9577) {
        if (textView.text.length > 0) {
            instrutionInputStr = textView.text;
            instrutionTipLable.hidden = YES;
        } else {
            instrutionTipLable.hidden = NO;
        }
        
    } else {
        keyStr = textView.text;
        [self requestSelectDrug];
    }
}
#pragma mark = 收起店铺 =
-(void)putawayOrderListAction:(UIButton*)sender{
    if (!sender.selected) {
        sender.selected = YES;
    } else {
        sender.selected = NO;
    }
    
    [(UITableView*)[[sender superview] superview] reloadData];
}

#pragma mark 杂项方法
- (void)ChangeDrugNums:(NSDictionary *)drugGoodsDic andShopTextF:(UITextField*)amountTextField andIndexpath:(NSIndexPath *)indexPath{
    for (int i = 0; i < myDrugsArray.count; i++) {
        NSDictionary *dic = myDrugsArray[i];
        NSMutableDictionary * nDict = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([drugGoodsDic[@"id"] isEqualToString:nDict[@"id"]]) {
            [myDrugsArray removeObjectAtIndex:i];
            if ([amountTextField.text integerValue] > 0) {
                [myDrugsArray addObject:nDict];
                [nDict setValue:amountTextField.text forKey:@"num"];
            } else {
                [myDrugsArray removeObject:nDict];
                [PrescriptionTableview reloadData];
            }
            break;
        }
    }
    float sunCount = 0.00;
    for (int i = 0; i < myDrugsArray.count ; i ++) {
        NSDictionary *dic = myDrugsArray[i];
        sunCount += ([dic[@"price"] floatValue] * [dic[@"num"] integerValue]);
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥%.2f",sunCount]];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, str.length - 3)];
    SumCountLable.attributedText = str;
    
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
