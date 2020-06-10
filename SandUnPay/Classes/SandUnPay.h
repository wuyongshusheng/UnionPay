//
//  SandUnPay.h
//  unpay
//
//  Created by tianNanYiHao on 2018/7/17.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SandUnPayInfo.h"
#import "UPPaymentControl.h"

/**
 支付结果回调

 @param code 回调code
 @param data 回调信息
 */
typedef void(^SandUnPyaResultBlock)(NSString *code , NSDictionary *data);

@interface SandUnPay : NSObject


/**
 SandUnPay 单例实例

 @return 实例
 */
+ (SandUnPay*)sharedInstance;


/**
 商户App加载秘钥
 ps:测试(01)模式下该方法参数可为空(将使用杉德分配的测试商户私钥秘钥)

 @param privateKyeName 秘钥名
 @param type 秘钥类型
 @param pwd 秘钥密码
 */
- (void)loadSandUnPay:(NSString*)privateKyeName privateKeyType:(NSString*)type privateKeyPwd:(NSString*)pwd;


/**
 唤起SandUnPaySDK

 @param payInfo 商户下单信息
 @param currentVc 当前视图控制器
 @param modeType 模式切换 生产(00)|测试(01)|开发(02)
 */
- (void)callSandUnPay:(SandUnPayInfo*)payInfo viewController:(UIViewController*)currentVc mode:(NSString *)modeType;



/**
 SandUnPaySDK 检测能否唤起银联支付相关的App(如银联云闪付)

 @return 返回能否唤起值
 */
- (BOOL)isSandUnPayCallApp;


/**
 银联支付相关的App跳转商户App,携带支付结果url

 @param url 支付结果url，传入后由SandUnPay SDK解析
 @param completionBlock 结果回调，保证跳转钱包支付过程中，即使调用方app被系统kill时，能通过这个回调取到支付结果。
 */
- (void)handleSandUnPayResult:(NSURL*)url completeBlock:(SandUnPyaResultBlock)completionBlock;


@end
