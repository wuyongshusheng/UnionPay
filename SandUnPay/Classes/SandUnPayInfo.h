//
//  SandUnPayInfo.h
//  unpay
//
//  Created by tianNanYiHao on 2018/7/19.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SandUnPayInfo : NSObject

/** 商户接入类型(1|2) */
@property (nonatomic ,strong) NSString *accessType;
/** 商户ID */
@property (nonatomic ,strong) NSString *mid;
/** 平台ID 仅在accessType(商户接入类型)为2时设置 */
@property (nonatomic ,strong) NSString *plMid;
/** 商户订单描述 */
@property (nonatomic ,strong) NSString *body;
/** 商户订单标题 */
@property (nonatomic ,strong) NSString *subject;
/** 商户订单号 */
@property (nonatomic ,strong) NSString *orderCode;
/** 订单金额 (分为单位的整数字符串)*/
@property (nonatomic ,strong) NSString *totalAmount;
/** 结果异步通知地址(URL) */
@property (nonatomic ,strong) NSString *notifyUrl;


@end
