//
//  LFSha1WithRsa.h
//  unpay
//
//  Created by tianNanYiHao on 2018/7/16.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFSha1WithRsa : NSObject

/**
 加载私钥

 @param privateKeyName 私钥名
 @param type 私钥后缀名(p12 / pfx ...)
 @param privatePwd 私钥密码
 */
- (void)rsaWihtrivateKeyName:(NSString*)privateKeyName tpye:(NSString*)type privatePwd:(NSString*)privatePwd;


/**
 SHA1+RSA方式签名

 @param plainText 签名字符串
 @return 加签后的字符串
 */
-(NSData *)signTheDataLFSha1WithRsa:(NSString *)plainText;

@end
