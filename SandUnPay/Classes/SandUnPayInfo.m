//
//  SandUnPayInfo.m
//  unpay
//
//  Created by tianNanYiHao on 2018/7/19.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SandUnPayInfo.h"

@implementation SandUnPayInfo

- (void)setAccessType:(NSString *)accessType{
    _accessType = accessType;
    if ([_accessType isEqualToString:@"1"]) {
        self.plMid = @"";
    }
}

- (void)setPlMid:(NSString *)plMid{
    _plMid = plMid;
    if ([_accessType isEqualToString:@"1"]) {
        _plMid = @"";
    }
}

- (void)setTotalAmount:(NSString *)totalAmount{
    _totalAmount = totalAmount;
    
    //1.将金额字符串 转为 整形数字 - 过滤掉输入错误的字符
    NSInteger inter = [_totalAmount integerValue];
    if (!inter) {
        inter = 0;
    }
    //2.将整型转为字符串
    NSString *amt = [NSString stringWithFormat:@"%ld",(long)inter];
    NSUInteger allLenth = 12;
    if (amt.length>12) {
        amt = @"000000000000";
        _totalAmount = amt;
        return;
    }
    
    allLenth = 12 - amt.length;
    for (int i = 0; i<allLenth; i++) {
        amt = [NSString stringWithFormat:@"%@%@",@"0",amt];
    }
    _totalAmount = amt;
}


@end
