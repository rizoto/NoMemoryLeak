//
//  NSObject+NoMemoryLeak.h
//  NoMemoryLeak
//
//  Created by Lubor Kolacny on 23/08/2015.
//  Copyright (c) 2015 Lubor Kolacny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NoMemoryLeak)

+ (NSInteger)getCounter;
+ (void)print;
+ (void)printWithClasses:(NSArray*)classes;

@end
