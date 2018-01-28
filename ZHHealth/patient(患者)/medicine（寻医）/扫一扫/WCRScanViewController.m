//
//  WCRScanViewController.m
//  ZHHealth
//
//  Created by U1KJ on 15/11/18.
//  Copyright © 2015年 U1KJ. All rights reserved.
//

#import "WCRScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WCRDoctorDetailController.h"
#import "BZDoctorModel.h"
#define QRCodeWidth  260.0   //正方形二维码的边长
@interface WCRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;//调用所有的输入硬件。例如摄像头和麦克风
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;// 控制输入和输出设备之间的数据传递
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;//镜头捕捉到得预览图层
@property (nonatomic,strong)  UIView *scanLine;

@end

@implementation WCRScanViewController
//- (void)viewDidLoad {
//    
//    [super viewDidLoad];
//    
////    [self onSetTitleView:@"二维码扫描结果"type:TitleLogo];//调用根视图的方法，自定义导航控制器的样式。这个根据读者的实际情况而定。
//    
////    self.navigationController.toolbarHidden = YES;//如果你的根视图有底部工具栏，这行代码可以隐藏底部的工具栏
//    
//    [self setupMaskView];//设置扫描区域之外的阴影视图
//    
//    
//    [self setupScanWindowView];//设置扫描二维码区域的视图
//    
//    
//    [self beginScanning];//开始扫二维码
//    
//}

- (void)setupMaskView

{
    
    //设置统一的视图颜色和视图的透明度
    
    UIColor *color = [UIColor blackColor];
    
    float alpha = 0.7;
    
    //设置扫描区域外部上部的视图
    
    UIView *topView = [[UIView alloc]init];
    
    topView.frame = CGRectMake(0, 64, kMainWidth, (kMainHeight-64-QRCodeWidth)/2.0-64);
    
    topView.backgroundColor = color;
    
    topView.alpha = alpha;
    
    //设置扫描区域外部左边的视图
    
    UIView *leftView = [[UIView alloc]init];
    
    leftView.frame = CGRectMake(0, 64+topView.frame.size.height, (kMainWidth-QRCodeWidth)/2.0,QRCodeWidth);
    
    leftView.backgroundColor = color;
    
    leftView.alpha = alpha;
    
    //设置扫描区域外部右边的视图
    
    UIView *rightView = [[UIView alloc]init];
    
    rightView.frame = CGRectMake((kMainWidth-QRCodeWidth)/2.0+QRCodeWidth,64+topView.frame.size.height, (kMainWidth-QRCodeWidth)/2.0,QRCodeWidth);
    
    rightView.backgroundColor = color;
    
    rightView.alpha = alpha;
    
    //设置扫描区域外部底部的视图
    
    UIView *botView = [[UIView alloc]init];
    
    botView.frame = CGRectMake(0, 64+QRCodeWidth+topView.frame.size.height,kMainWidth,kMainHeight-64-QRCodeWidth-topView.frame.size.height);
    
    botView.backgroundColor = color;
    
    botView.alpha = alpha;
    
    //将设置好的扫描二维码区域之外的视图添加到视图图层上
    
    [self.view addSubview:topView];
    
    [self.view addSubview:leftView];
    
    [self.view addSubview:rightView];
    
    [self.view addSubview:botView];
    
}

- (void)setupScanWindowView

{
    
    //设置扫描区域的位置(考虑导航栏和电池条的高度为64)
    
    UIView *scanWindow = [[UIView alloc]initWithFrame:CGRectMake((kMainWidth-QRCodeWidth)/2.0,(kMainHeight-QRCodeWidth-64)/2.0,QRCodeWidth,QRCodeWidth)];
    
    scanWindow.clipsToBounds = YES;
    
    [self.view addSubview:scanWindow];
    
    
    //设置扫描区域的动画效果
    UIView *scanLine = [[UIView alloc] init];
    _scanLine = scanLine;
    CGFloat scanLineW = scanWindow.frame.size.width;
    CGFloat scanLineH = scanWindow.frame.size.height;
    scanLine.frame = CGRectMake(0, 0, scanLineW, 1);
    scanLine.backgroundColor = [UIColor redColor];
       [scanWindow addSubview:scanLine];
    [UIView animateWithDuration:2 delay:0.0 options:UIViewAnimationOptionRepeat  animations:^{
        scanLine.y_wcr = scanLineH;
    } completion:^(BOOL finished) {
        
    }];

    
    //设置扫描区域的四个角的边框
//    
//    CGFloat buttonWH = 18;
//    
//    UIButton *topLeft = [[UIButton alloc]initWithFrame:CGRectMake(0,0, buttonWH, buttonWH)];
//    
//    [topLeft setImage:[UIImage imageNamed:@"accept_btn_normal"]forState:UIControlStateNormal];
//    
//    [scanWindow addSubview:topLeft];
//    
//    
//    UIButton *topRight = [[UIButton alloc]initWithFrame:CGRectMake(QRCodeWidth - buttonWH,0, buttonWH, buttonWH)];
//    
//    [topRight setImage:[UIImage imageNamed:@"accept_btn_normal"]forState:UIControlStateNormal];
//    
//    [scanWindow addSubview:topRight];
//    
//    
//    UIButton *bottomLeft = [[UIButton alloc]initWithFrame:CGRectMake(0,QRCodeWidth - buttonWH, buttonWH, buttonWH)];
//    
//    [bottomLeft setImage:[UIImage imageNamed:@"accept_btn_normal"]forState:UIControlStateNormal];
//    
//    [scanWindow addSubview:bottomLeft];
//    
//    
//    UIButton *bottomRight = [[UIButton alloc]initWithFrame:CGRectMake(QRCodeWidth-buttonWH,QRCodeWidth-buttonWH, buttonWH, buttonWH)];
//    
//    [bottomRight setImage:[UIImage imageNamed:@"accept_btn_normal"]forState:UIControlStateNormal];
//    
//    [scanWindow addSubview:bottomRight];
    
}

- (void)beginScanning

{
    
    //获取摄像设备
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入流
    
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (!input) return;
    
    //创建输出流
    
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    
    //特别注意的地方：有效的扫描区域，定位是以设置的右顶点为原点。屏幕宽所在的那条线为y轴，屏幕高所在的线为x轴
    
    CGFloat x = ((kMainHeight-QRCodeWidth-64)/2.0)/kMainHeight;
    
    CGFloat y = ((kMainWidth-QRCodeWidth)/2.0)/kMainWidth;
    
    CGFloat width = QRCodeWidth/kMainWidth;
    
    CGFloat height = QRCodeWidth/kMainHeight;
    
    output.rectOfInterest = CGRectMake(x, y, width, height);
    
    //设置代理在主线程里刷新
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    //初始化链接对象
    
    _session = [[AVCaptureSession alloc]init];
    
    //高质量采集率
    
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    
    [_session addInput:input];
    
    [_session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    layer.frame=self.view.layer.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    
    [_session startRunning];
    
    
}

//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray*)metadataObjects fromConnection:(AVCaptureConnection *)connection{
//    
//    if (metadataObjects.count>0) {
//        
//        [_session stopRunning];
//        
//        //得到二维码上的所有数据
//        
//        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0 ];
//        
//        NSString *str = metadataObject.stringValue;
//        
//        NSLog(@"%@",str);
//        
//    }
//    
//}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBackBtn];
    
//    [self setNavigationBarProperty];
    
    self.title = @"扫码";

    [self customScanUI];

    [self setupScanWindowView];//设置扫描二维码区域的视图
    [self setupMaskView];//设置扫描区域之外的阴影视图
    
}
-(void)addLeftBackBtn
{
    
    float width = 17;
    float height = 17;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    UIImage *image = [UIImage imageNamed:@"arrow"];
    
    [button setBackgroundImage:image forState:0];
    [button setEnlargeEdgeWithTop:10 right:20 bottom:0 left:20];
    
    [button addTarget:self action:@selector(backLeftNavItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backLeftNavItemAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.tabBarController.selectedIndex = 0;
}
-(void)customScanUI {

    // 初始化
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [ _output setRectOfInterest : CGRectMake (( 124 )/ kMainHeight ,(( kMainWidth - 220 )/ 2 )/ kMainWidth , 220 / kMainHeight , 220 / kMainWidth )];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output])  
    {
        [self.session addOutput:self.output];
    } 
    
    // 条码类型
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    self.preview.frame =CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [self.view.layer addSublayer:self.preview];
    
    // Start
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
    }
      [_session stopRunning];
    [_scanLine removeFromSuperview];
    // 跳转到医生界面
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"] = stringValue;
    [httpUtil doPostRequest:@"api/ZhengheDoctor/scanCode" args:args targetVC:self response:^(ResponseModel *responseMd) {
        if (responseMd.isResultOk) {
            if (responseMd.response == nil) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"找不到信息，请重新扫描" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    WCRScanViewController *scanVC = [[WCRScanViewController alloc]init];
                    scanVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:scanVC animated:YES];
                }];
                [alert addAction:okAction];
                
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                BZDoctorModel *doctorModel = [BZDoctorModel mj_objectWithKeyValues:responseMd.response];
                WCRDoctorDetailController *doctorDetailVC = [[WCRDoctorDetailController alloc]init];
                doctorDetailVC.doctor = doctorModel;
                [self.navigationController pushViewController:doctorDetailVC animated:YES];

            }
      }
}];

}










@end
