//
//  SGCustomObjectsComparator.m
//  Test
//
//  Created by songgeb on 2018/7/25.
//  Copyright © 2018年 songgeb. All rights reserved.
//

#import "SGModelComparator.h"
#import <objc/runtime.h>

@implementation SGModelComparator

+ (BOOL)isCustomA:(id)objecta equalToB:(id)objectb {
    NSParameterAssert([objecta isKindOfClass:[NSObject class]]);
    NSParameterAssert([objectb isKindOfClass:[NSObject class]]);
    if (objecta == objectb) { return YES; }
    
    NSDictionary *ivarAndValues1 = [self extractIVarFromObj:objecta];
    NSDictionary *ivarAndValues2 = [self extractIVarFromObj:objectb];
    
    NSLog(@"1-->%@", ivarAndValues1);
    NSLog(@"2-->%@", ivarAndValues2);
    
    return [ivarAndValues1 isEqual:ivarAndValues2];
}

+ (NSDictionary *)extractIVarFromObj:(NSObject *)obj {
    return [self extractIVarFromObj:obj prefix:nil];
}

//不支持系统类，仅支持自定义类
+ (NSDictionary *)extractIVarFromObj:(NSObject *)obj prefix:(NSString *)prefix {
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([obj class], &count);
    if (count <= 0) { return nil; }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        const char *name = ivar_getName(ivar);
        //        id value = object_getIvar(a, ivar);//objc_getIvar--只能获取oc对象,所以弃用
        id value = [obj valueForKey:[NSString stringWithUTF8String:name]];//经测试，value返回值看上去都是NSObject的子类
        if (value == nil) { continue; }
        if ([self isCustomClass:(NSObject *)value]) {
            [dict addEntriesFromDictionary:[self extractIVarFromObj:value prefix:[NSString stringWithUTF8String:name]]];
        } else {
            if (prefix == nil) { prefix = @""; }
            //如果是集合类
            if ([value isKindOfClass:[NSArray class]]) {
                NSArray *tmpArray = (NSArray *)value;
                for (int j = 0; j < tmpArray.count; j++) {
                    id subObj = tmpArray[j];
                    NSString *subPrefix = [NSString stringWithFormat:@"%@.%s.%d", prefix, name, j];
                    [dict addEntriesFromDictionary:[self extractIVarFromObj:subObj prefix:subPrefix]];
                }
            } else if ([value isKindOfClass:[NSSet class]]) {
                NSSet *subSet = (NSSet *)value;
                for (id subObj in subSet) {
                    NSString *subPrefix = [NSString stringWithFormat:@"%@.%s.set", prefix, name];
                    [dict addEntriesFromDictionary:[self extractIVarFromObj:subObj prefix:subPrefix]];
                }
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                NSDictionary *subDict = (NSDictionary *)value;
                for (id key in subDict.allKeys) {
                    id subObj = subDict[key];
                    NSString *subPrefix = [NSString stringWithFormat:@"%@.%s.%@", prefix, name, key];// TODO此处使用%@和key对应不知道可不可以
                    [dict addEntriesFromDictionary:[self extractIVarFromObj:subObj prefix:subPrefix]];
                }
            } else {
                NSString *key = [NSString stringWithFormat:@"%@.%s", prefix, name];
                dict[key] = value;
            }
        }
    }
    return dict;
}

+ (BOOL)isCustomClass:(NSObject *)obj {
    NSParameterAssert(obj);
    NSBundle *bundle = [NSBundle bundleForClass:[obj class]];
    if (bundle == [NSBundle mainBundle]) {
        return YES;
    } else {
        return NO;
    }
}

@end
