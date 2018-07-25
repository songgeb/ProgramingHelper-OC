//
//  SGCustomObjectsComparator.h
//  Test
//
//  Created by songgeb on 2018/7/25.
//  Copyright © 2018年 songgeb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGModelComparator : NSObject


/**
 比较两个自定义对象内容是否完全相同(仅限自定义类)
 同时会在控制台打印两个对象所有属性及值

 @param objecta 自定义类A
 @param objectb 自定义类B
 @return YES:相同, NO:不同
 */
+ (BOOL)isCustomA:(id)objecta equalToB:(id)objectb;

@end
