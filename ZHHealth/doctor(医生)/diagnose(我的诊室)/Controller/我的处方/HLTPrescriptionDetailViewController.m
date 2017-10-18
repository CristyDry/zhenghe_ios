//
//  HLTPrescriptionDetailViewController.m
//  ZHHealth
//
//  Created by GaoLiang on 2017/10/13.
//  Copyright © 2017年 U1KJ. All rights reserved.
//

#import "HLTPrescriptionDetailViewController.h"

@interface HLTPrescriptionDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UILabel *ChuFangShopLable;
    // 处方患者信息
    __weak IBOutlet UITextField *ChuFangLable;    // 单号
    __weak IBOutlet UILabel *ChuFangName;         // 病人
    __weak IBOutlet UILabel *ChuFangTelLable;     // 病人电话
    __weak IBOutlet UILabel *ChuFangAgeLable;     // 病人年龄
    __weak IBOutlet UILabel *ChuFangOtherLable;   // 病人症状
    
    __weak IBOutlet UIButton *SexManBtn;          // 病人性别
    __weak IBOutlet UIButton *SexWomanBtn;
    
    __weak IBOutlet UITableView *ChuFangTableView;
    
    __weak IBOutlet UILabel *SumCountLable;
    NSMutableArray *medicineArray;
}
@end

@implementation HLTPrescriptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBackItem];
    [self setNavigationBarProperty];
    
    [self setDetailUIAction];

}
#pragma mark 搭建UI 数据赋值 
- (void)setDetailUIAction {
    ChuFangTableView.dataSource = self;
    ChuFangTableView.delegate = self;
    @try {
        ChuFangShopLable.text = [NSString stringWithFormat:@"%@",self.chuFangDic[@"departmentName"]];
        ChuFangLable.text = [NSString stringWithFormat:@"%@",self.chuFangDic[@"rxNo"]];
        ChuFangName.text = [NSString stringWithFormat:@"%@",self.chuFangDic[@"patientName"]];
        ChuFangTelLable.text = [NSString stringWithFormat:@"%@",self.chuFangDic[@"patientPhone"]];
        ChuFangAgeLable.text = [NSString stringWithFormat:@"%@",self.chuFangDic[@"patientAge"]];
        ChuFangOtherLable.text = [NSString stringWithFormat:@"%@",self.chuFangDic[@"clinicalDiagnosis"]];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：¥%.2f",[self.chuFangDic[@"totalAmount"] floatValue]]];
        //设置文字颜色
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3, str.length - 3)];
        SumCountLable.attributedText = str;
        if ([self.chuFangDic[@"patientGender"] isEqualToString:@"男"]) {
            SexManBtn.selected = YES;
            SexWomanBtn.selected = NO;
        } else {
            SexManBtn.selected = NO;
            SexWomanBtn.selected = YES;
        }
        medicineArray = self.chuFangDic[@"zhengheRxDetailList"];
        [ChuFangTableView reloadData];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
#pragma mark UITableview Datadouce
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return medicineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *medicineCell = [tableView dequeueReusableCellWithIdentifier:@"DrugMessageCell" forIndexPath:indexPath];
    NSDictionary *medicineDic = medicineArray[indexPath.row];
    UIImageView *iconView = [medicineCell viewWithTag:8800];
    UILabel *medicineNameLable = [medicineCell viewWithTag:8801];
    UILabel *medicinePriceLable = [medicineCell viewWithTag:8802];
    UILabel *medicineTypeLable = [medicineCell viewWithTag:8803];
    UILabel *medicineNumLbale = [medicineCell viewWithTag:8804];
    
    [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",medicineDic[@"imgUrl"]]] placeholderImage:[UIImage imageNamed:@"ic_error"]];
    medicineNameLable.text = [NSString stringWithFormat:@"%@",medicineDic[@"productName"]];
    medicinePriceLable.text = [NSString stringWithFormat:@"¥%@",medicineDic[@"price"]];
    medicineTypeLable.text = [NSString stringWithFormat:@"%@",medicineDic[@"standard"]];
    medicineNumLbale.text = [NSString stringWithFormat:@"%@",medicineDic[@"num"]];
    return medicineCell;
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
