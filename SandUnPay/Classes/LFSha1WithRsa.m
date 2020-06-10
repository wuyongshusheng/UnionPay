//
//  LFSha1WithRsa.m
//  unpay
//
//  Created by tianNanYiHao on 2018/7/16.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "LFSha1WithRsa.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "LFBase64Util.h"


#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH  // SHA-1消息摘要的数据位数160位

@interface LFSha1WithRsa()
{
    
    
}
@property (nonatomic, strong) NSString *privateKeyName;
@property (nonatomic, strong) NSString *privateKeyType;
@property (nonatomic, strong) NSString *privateKeyPwd;
@end

@implementation LFSha1WithRsa


#pragma mark - init
- (instancetype)init{
    if ([super init]) {
        self.privateKeyPwd = @"";
        self.privateKeyName = @"";
    }
    return self;
}



#pragma mark - sha1
- (NSData *)getHashBytes:(NSData *)plainText {
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( kChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kChosenDigestLength);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[plainText bytes], [plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
    if (hashBytes) free(hashBytes);
    
    return hash;
}




#pragma mark - load PrivateKey
- (void)rsaWihtrivateKeyName:(NSString*)privateKeyName tpye:(NSString*)type privatePwd:(NSString*)privatePwd{
    self.privateKeyName = privateKeyName;
    self.privateKeyType = type;
    self.privateKeyPwd = privatePwd;
    
}

#pragma mark - rsa
-(NSData *)signTheDataLFSha1WithRsa:(NSString *)plainText
{
    uint8_t* signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;
    
    NSData * data = [NSData new];
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init]; // Set the private key query dictionary.
    
    //读取外部私钥 - 由商户App开发人员提供
    if (self.privateKeyName.length>0 && self.privateKeyPwd.length>0 && self.privateKeyType.length>0) {
        NSString * path = [[NSBundle mainBundle] pathForResource:self.privateKeyName ofType:self.privateKeyType];
        data = [NSData dataWithContentsOfFile:path];
        [options setObject:self.privateKeyPwd forKey:(id)kSecImportExportPassphrase];
    }
    
    //读取测试私钥 - 由杉德内部提供的测试商户的私钥
    else{
        //获取私钥证书文件且将data数据转为base64字符串后,注释掉这部分
        //    NSString * path = [[NSBundle mainBundle]pathForResource:@"mid-test" ofType:@"pfx"];
        //    NSData * data = [NSData dataWithContentsOfFile:path];
        //    NSString *s = [LFBase64Util base64EncodedStringFrom:data];
        
        NSString *s = @"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";
        data = [LFBase64Util dataWithBase64EncodedString:s];
        [options setObject:@"123456" forKey:(id)kSecImportExportPassphrase];
    }
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((CFDataRef) data, (CFDictionaryRef)options, &items);
    if (securityError!=noErr) {
        return nil ;
    }
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    SecKeyRef privateKeyRef=nil;
    SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
    signedBytesSize = SecKeyGetBlockSize(privateKeyRef);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) ); // Malloc a buffer to hold signature.
    memset((void *)signedBytes, 0x0, signedBytesSize);
    
    sanityCheck = SecKeyRawSign(privateKeyRef,
                                kSecPaddingPKCS1SHA1,
                                (const uint8_t *)[[self getHashBytes:plainTextBytes] bytes],
                                kChosenDigestLength,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    
    if (sanityCheck == noErr)
    {
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    }
    else
    {
        return nil;
    }
    
    if (signedBytes)
    {
        free(signedBytes);
    }
    //    NSString *signatureResult=[NSString stringWithFormat:@"%@",[signedHash base64EncodedString]];
    return signedHash;
}


@end
