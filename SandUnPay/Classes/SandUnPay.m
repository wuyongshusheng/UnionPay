//
//  SandUnPay.m
//  unpay
//
//  Created by tianNanYiHao on 2018/7/17.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SandUnPay.h"
#import "LFBase64Util.h"
#import "LFSha1WithRsa.h"
#import "MBProgressHUD.h"
#import "LFIPAddressUtil.h"

#define SchemeStr @"SandUnPay"
#define POSTURL_SAND_TEST @"http://172.28.247.111:8083/qr/api/order/pay" //111:测试   - 供杉德开发人员使用
#define POSTURL_TEST @"http://61.129.71.103:8003/gateway/api/order/pay"  //商户测试环境 - 供商户App开发人员使用
#define POSTURL_SC   @"https://cashier.sandpay.com.cn/gateway/api/order/pay"   //商户生产环境 - 供商户App开发人员使用

@interface SandUnPay(){
    
    LFSha1WithRsa *sha1Rsa;
    NSString *prvKeyName;  //私钥名
    NSString *prvKeyType;  //私钥类型
    NSString *prvKeyPwd;   //私钥密码
}
@property (nonatomic, strong) NSString *postUrl;  //地址
@property (nonatomic, strong) MBProgressHUD *hud; //hud
@property (nonatomic, strong) UIViewController *presentedVC;  //当前控制器
@property (nonatomic, strong) NSString *modeType;  //模式


@end

@implementation SandUnPay


#pragma mark - init
//1.静态初始化
static SandUnPay *SandUnPaySharedInstance = nil;

//2.单例实例化 - 共享实例
+ (SandUnPay*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SandUnPaySharedInstance = [[SandUnPay alloc] init];
    });
    return SandUnPaySharedInstance;
}

//3.init单例
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([super init]) {
         
        }
    });
    return self;
}



#pragma mark- work
#pragma mark- 外部调用方法

#pragma mark 加载商户App私钥
- (void)loadSandUnPay:(NSString*)privateKyeName privateKeyType:(NSString*)type privateKeyPwd:(NSString*)pwd{
    prvKeyName = privateKyeName;
    prvKeyType = type;
    prvKeyPwd = pwd;
}

#pragma mark 调用SandUnPay SDK
- (void)callSandUnPay:(SandUnPayInfo*)payInfo viewController:(UIViewController*)currentVc mode:(NSString *)modeType{
    
    //0. 测试/生产环境配置
    [self setInfo:currentVc mode:modeType];
    
    //1.组装data数据模块
    NSString *dataJsonString =  [self getDdata:payInfo];
    
    if (dataJsonString.length>0) {
    //2.组装url请求
        NSMutableURLRequest *urlRequest = [self getUrlRequest:dataJsonString];
    //3.发送http请求获取TN
        [self httpRequest:urlRequest];
    }

}
#pragma mark 判断能否调起银联相关支付App
- (BOOL)isSandUnPayCallApp{
   // APP是否已安装检测接口，通过该接口得知用户是否安装银联支付的APP
   return [[UPPaymentControl defaultControl] isPaymentAppInstalled];
}
#pragma mark 支付结果回调
- (void)handleSandUnPayResult:(NSURL *)url completeBlock:(SandUnPyaResultBlock)completionBlock{
    //处理钱包或者独立快捷app支付跳回商户app携带的支付结果Url
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:completionBlock];
}


#pragma mark- 内部私有方法

#pragma mark 生产/测试环境配置
- (void)setInfo:(UIViewController*)currentVc mode:(NSString *)modeType{
    
    // 获取视图控制器
    self.presentedVC = currentVc;
    
    // 获取模式类型
    self.modeType = modeType;
    
    // 秘钥类初始化
    sha1Rsa = [[LFSha1WithRsa alloc] init];
    
    // 模式切换
    if ([modeType isEqualToString:@"00"]) {  //生产
        self.postUrl = POSTURL_SC;
        if (prvKeyName.length>0 && prvKeyType.length>0 && prvKeyPwd.length>0) {
            //加载秘钥 - 必须加载
            [sha1Rsa rsaWihtrivateKeyName:prvKeyName tpye:prvKeyType privatePwd:prvKeyPwd];
        }else{
            [self alertShow:@"未检测到秘钥!" message:@"商户私钥证书未能读取"];
            return;
        }
    }
    else if ([modeType isEqualToString:@"01"]){ //测试
        self.postUrl = POSTURL_TEST;
        //加载秘钥 - 使用杉德测试商户的测试私钥
        [sha1Rsa rsaWihtrivateKeyName:@"" tpye:@"" privatePwd:@""];
    }
    else if ([modeType isEqualToString:@"02"]){
        self.postUrl = POSTURL_SAND_TEST;  //开发
        //加载秘钥 - 使用杉德测试商户的测试私钥
        [sha1Rsa rsaWihtrivateKeyName:@"" tpye:@"" privatePwd:@""];
        
        //开发模式判断完成, 需让银联SDK走测试模式
        self.modeType = @"01";
    }
}


#pragma mark 组装data数据模块
- (NSString *)getDdata:(SandUnPayInfo*)payInfo{
    
    BOOL dataSave = [self checkPayInfo:payInfo];
    
    if (dataSave) {
        
        //获取时间数据
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddhhmmss";
        NSString *nowTime = [formatter stringFromDate:date];
        
        //获取Ip地址数据 -
        NSString *nowIpAddress = [LFIPAddressUtil getIPAddress:YES];
        
        //data:数据
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        NSDictionary *headDic = @{
                                  @"accessType":payInfo.accessType,
                                  @"channelType":@"07",
                                  @"method":@"sandpay.trade.pay",
                                  @"mid":payInfo.mid,
                                  @"plMid":payInfo.plMid,
                                  @"productId":@"00000030",
                                  @"reqTime":nowTime,
                                  @"subMid":@"",
                                  @"subMidAddr":@"",
                                  @"subMidName":@"",
                                  @"version":@"1.0"
                                  };
        
        NSDictionary *bodyDic = @{
                                  @"bizExtendParams":@"",
                                  @"body":payInfo.body,
                                  @"clearCycle":@"",
                                  @"clientIp":nowIpAddress,
                                  @"extend":@"",
                                  @"frontUrl":@"",
                                  @"merchExtendParams":@"",
                                  @"notifyUrl":payInfo.notifyUrl,
                                  @"operatorId":@"",
                                  @"orderCode":payInfo.orderCode,
                                  @"payExtra":@"",
                                  @"payMode":@"sand_upsdk",
                                  @"storeId":@"",
                                  @"subject":payInfo.subject,
                                  @"terminalId":@"",
                                  @"totalAmount":payInfo.totalAmount,
                                  @"txnTimeOut":@""
                                  };
        
        [params setObject:headDic forKey:@"head"];
        [params setObject:bodyDic forKey:@"body"];
        
        
        //-=-=--=
        
        
        
        
        //data To jsonString
        NSString *jsonString = @"";
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        if (!data) {
            //入参有误
            return @"";
        }else{
            jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        return jsonString;  //返回jsonString 已确保准确,如果参数有误则在上面拦截
    }
    else{
        return @"";
    }
    
}
#pragma mark 组装url请求
- (NSMutableURLRequest*)getUrlRequest:(NSString *)dataString{
    
    //---------------请求数据加签处理---------------
    //对data数据进行sha1+rsa私钥加签 后 base64转码
    NSData *sha1RsaData = [sha1Rsa signTheDataLFSha1WithRsa:dataString];
    NSString *sha1RsaData_To_Base64String = [LFBase64Util base64EncodedStringFrom:sha1RsaData];
    
    //data
    NSString *bodyString = [NSString stringWithFormat:@"charset=%@&signType=%@&sign=%@&data=%@",@"UTF-8",@"01",sha1RsaData_To_Base64String,dataString];
    
    //---------------发起请求代码处理---------------
    //URL
    NSURL *url = [NSURL URLWithString:self.postUrl];
    
    //Request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; //默认就是这个(可不设置该项)
    urlRequest.HTTPMethod = @"POST";
    urlRequest.timeoutInterval = 45; //超时时间45s
    urlRequest.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    return urlRequest;
}

#pragma mark 发送http请求获取TN
- (void)httpRequest:(NSURLRequest*)urlRequest{
    __weak typeof(self) weakSelf = self;
    
    //NSURLSession
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    //HUD - Start
    [self mbprogressHUD:self.presentedVC isShow:YES];
    //开启异步线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLSessionTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            //返回主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //HUD - Hidden
                [strongSelf mbprogressHUD:strongSelf.presentedVC isShow:NO];
                
                //返回有数据
                if (data) {
                    NSString *responseStr = @"";
                    responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    //dataStr 中文转码
                    responseStr = [responseStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    //返回数据格式校验 - 确保数据能够正确解析
                    if (responseStr.length>0 && !([responseStr rangeOfString:@"&"].location != NSNotFound)) {
                        [strongSelf alertShow:@"数据格式有误!" message:@"下单请求,返回数据格式错误"];
                        return ;
                    }
                    //数据处理以及解析
                    NSArray *responseArr = [responseStr componentsSeparatedByString:@"&"];
                    NSArray *dataArr = [[responseArr lastObject] componentsSeparatedByString:@"="];
                    NSString *dataJsonString = [dataArr lastObject];
                    NSData *dataStringData = [dataJsonString dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:dataStringData options:NSJSONReadingMutableLeaves error:nil];
                    NSDictionary *headDic = [dataDic objectForKey:@"head"];
                    NSDictionary *bodyDic = [dataDic objectForKey:@"body"];
                    NSString *respMsg = headDic[@"respMsg"];
                    NSString *respCode = headDic[@"respCode"];
                    
                    //获取TN成功 - 起调银联SDK
                    if ([@"000000" isEqualToString:respCode]) {
                        
                        //解析获取TN号
                        NSString *credential = bodyDic[@"credential"];
                        NSData *credentialData = [credential dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *credentialDic = [NSJSONSerialization JSONObjectWithData:credentialData options:NSJSONReadingMutableLeaves error:nil];
                        NSString *tn = credentialDic[@"tn"];
                        
                        
                        //获取TN成功
                        if ([strongSelf isSandUnPayCallApp]) {
                            //拿到TN 起调银联SDK (支付接口)
                            [[UPPaymentControl defaultControl] startPay:@"" fromScheme:SchemeStr mode:strongSelf.modeType viewController:strongSelf.presentedVC];
                        }else{
                            [strongSelf alertShow:@"您尚未安装银联云闪付App" message:@""];
                        }
                    }
                    //获取TN失败 - 透传各种错误提示!
                    else{
                        [strongSelf alertShow:@"下单失败!" message:respMsg];
                    }
                }
                //返回错误
                else if (error){
                    [strongSelf alertShow:@"下单失败!" message:@"网络通信异常"];
                }
            });
        }];
        
        [task resume];
    });

}

#pragma mark 校验入参数据
- (BOOL)checkPayInfo:(SandUnPayInfo*)p{
    
    if (p.accessType.length == 0) {
        [self alertShow:@"参数[accessType]未设置" message:@""];
        return NO;
    }
    else if (p.mid.length == 0) {
        [self alertShow:@"参数[mid]未设置" message:@""];
        return NO;
    }
    else if (p.plMid.length == 0 && [p.accessType isEqualToString:@"2"]) {
        [self alertShow:@"参数[plMid]未设置" message:@""];
        return NO;
    }
    
    else if (p.body.length == 0) {
        [self alertShow:@"参数[body]未设置" message:@""];
        return NO;
    }
    else if (p.subject.length == 0) {
        [self alertShow:@"参数[subject]未设置" message:@""];
        return NO;
    }
    else if (p.orderCode.length == 0) {
        [self alertShow:@"参数[orderCode]未设置" message:@""];
        return NO;
    }
    else if (p.totalAmount.length == 0 || [p.totalAmount isEqualToString:@"000000000000"]) {
        [self alertShow:@"参数[totalAmount]未设置" message:@""];
        return NO;
    }
    else if (p.notifyUrl.length == 0) {
        [self alertShow:@"参数[notifyUrl]未设置" message:@""];
        return NO;
    }
    else{
        return YES;
    }
}


#pragma mark HUD
- (void)mbprogressHUD:(UIViewController*)presentedVC isShow:(BOOL)isShow{
    if (isShow) {
        self.hud = [MBProgressHUD showHUDAddedTo:presentedVC.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.removeFromSuperViewOnHide = YES;
        self.hud.label.text = @"生成订单中...";
        [self.hud showAnimated:YES];
    }else{
        [self.hud hideAnimated:NO];
    }
}

#pragma mark Alert
- (void)alertShow:(NSString *)tipString message:(NSString*)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tipString message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acthion = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:acthion];
    [self.presentedVC presentViewController:alertController animated:YES completion:nil];
}

@end
