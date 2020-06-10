//
//  LFIPAddressUtil.h
//  unpay
//
//  Created by tianNanYiHao on 2018/7/19.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFIPAddressUtil : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

@end
