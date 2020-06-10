//
//  LFFViewController.m
//  SandUnPay
//
//  Created by tianNanYiHao on 07/20/2018.
//  Copyright (c) 2018 tianNanYiHao. All rights reserved.
//

#import "LFFViewController.h"

#import "SandUnPay.h"

@interface LFFViewController ()

@end

@implementation LFFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //00 - 商户生产模式 - 加载私钥方法必须调用
    //01 - 商户测试模式 - 使用杉德私钥，加载私钥方法可不调用
    //02 - 杉德开发模式 - 使用杉德私钥，加载私钥方法可不调用
    NSString *type = @"02";
    
    //必填信息
    SandUnPayInfo *info = [SandUnPayInfo new];
    info.accessType = @"1";
    info.mid = @"16335421";
    info.plMid = @"";
    info.subject = @"订单标题";
    info.body = @"订单描述";
    info.orderCode = @"saf02340230";  //订单编号
    info.totalAmount = @"1"; //订单金额(分为单位的整数数字符串)
    info.notifyUrl = @"http://101.231.114.216:1725/sim/getacptn";
    
    //1.加载秘钥
    [[SandUnPay sharedInstance] loadSandUnPay:nil privateKeyType:nil privateKeyPwd:nil];
    //2.起调SandUnPay SDK
    [[SandUnPay sharedInstance] callSandUnPay:info viewController:self mode:type];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
