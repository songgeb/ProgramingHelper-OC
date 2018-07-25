//
//  ORMViewController.m
//  Test
//
//  Created by songgeb on 2018/7/25.
//  Copyright © 2018年 songgeb. All rights reserved.
//

#import "ModelComparatorModels.h"
#import "SGModelComparator.h"

@interface SBB : NSObject
@property(nonatomic, copy) NSString *propertyInSBB;
@end

@implementation SBB
- (instancetype)init {
    self = [super init];
    if (self) {
        _propertyInSBB = @"property in SBB!";
    }
    return self;
}
@end

@interface SBA : NSObject
@property (nonatomic, assign) double numberdb;
@property (nonatomic, assign) float numberf;
@property (nonatomic, assign) char c;
@property (nonatomic, assign) BOOL isTrue;
@property (nonatomic, assign) int number;
@property (nonatomic, copy) NSString *str;
@property (nonatomic, strong) SBB *bb;
@property (nonatomic, strong) NSArray<SBB *> *bs;
@property (nonatomic, strong) NSMutableArray *lala;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSSet *set;
@end

@implementation SBA
- (instancetype)init {
    self = [super init];
    if (self) {
        _numberdb = 0.78;
        _numberf = 1.111;
        _c = 'n';
        _isTrue = YES;
        _number = -9;
        _str =@"what";
        _bb = [SBB new];
        _bs = @[[SBB new]];
        _lala = [NSMutableArray arrayWithArray:@[[SBB new]]];
        _dict = @{@"keykkk": [SBB new]};
        _set = [NSSet setWithObjects:[SBB new], nil];
    }
    return self;
}
@end

@implementation ModelComparatorModels

+ (void)testModelComparator {
    SBA *a1 = [[SBA alloc] init];
    SBA *a = [[SBA alloc] init];
    
    if ([SGModelComparator isCustomA:a equalToB:a1]) {
        NSLog(@"相等!");
    } else {
        NSLog(@"不相等!");
    }
}

@end
