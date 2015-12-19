//
//  UniqueUDID.m
//  CloudPhone
//
//  Created by wangcong on 15/12/18.
//  Copyright © 2015年 iTal. All rights reserved.
//

#import "UniqueUDID.h"
#import <Security/Security.h>


#define KEY_UDID            @"KEY_UDID"
#define KEY_IN_KEYCHAIN     @"KEY_IN_KEYCHAIN"

@implementation UniqueUDID


+(instancetype)shareInstance {
    static UniqueUDID *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UniqueUDID alloc]init];
    });
    return instance;
}

- (NSString *)openUDID {

    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}

- (NSString *)udid {

    return [[UniqueUDID shareInstance] readUDID];
}

#pragma mark 保存udid到钥匙串
- (void)saveUDID:(NSString *)udid {

    NSMutableDictionary *udidKCPairs = [NSMutableDictionary dictionary];
    [udidKCPairs setObject:udid forKey:KEY_UDID];
    [[UniqueUDID shareInstance] save:KEY_IN_KEYCHAIN data:udidKCPairs];
}

#pragma mark 读取UUID
/**
 *先从内存中获取uuid，如果没有再从钥匙串中获取，如果还没有就生成一个新的uuid，并保存到钥匙串中供以后使用
 **/
- (NSString *)readUDID
{
    if (_udid == nil || _udid.length == 0) {
        NSMutableDictionary *udidKVPairs = (NSMutableDictionary *)[[UniqueUDID shareInstance] load:KEY_IN_KEYCHAIN];
        
        NSString *tempudid = [udidKVPairs objectForKey:KEY_UDID];
        if (tempudid == nil || tempudid.length == 0) {
            tempudid = [self openUDID];
            [self saveUDID:tempudid];
        }
        _udid = tempudid;
    }
    return _udid;
}

#pragma mark 删除UUID
- (void)deleteUUID
{
    [self delete:KEY_IN_KEYCHAIN];
}

#pragma mark 查询钥匙串
- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil ,nil];
}

#pragma mark 将数据保存到钥匙串
- (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

#pragma mark 加载钥匙串中数据
- (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

#pragma mark 删除钥匙串中数据
- (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}


@end
