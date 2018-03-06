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
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (strong,nonatomic)UIView * scanLine;


@end

@implementation WCRScanViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBackBtn];
    
//    [self setNavigationBarProperty];
    
    self.title = @"扫码";

    //[self customScanUI];

    [self setupScanWindowView];//设置扫描二维码区域的视图
    [self setupMaskView];//设置扫描区域之外的阴影视图
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];

    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];

}

-(void)viewDidAppear:(BOOL)animated{
    [_session startRunning];
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

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
    }
      [_session stopRunning];
    //[_scanLine removeFromSuperview];
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
