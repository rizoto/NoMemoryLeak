//
//  NSObject+NoMemoryLeak.m
//  NoMemoryLeak
//
//  Created by Lubor Kolacny on 23/08/2015.
//  Copyright (c) 2015 Lubor Kolacny. All rights reserved.
//

#import "NSObject+NoMemoryLeak.h"
#import "RSSwizzle.h"

@implementation NSObject (NoMemoryLeak)

+ (void)load
{
    NSLog(@"load class: %@", [self class]);
    NSMutableDictionary *_md = [NSMutableDictionary dictionaryWithCapacity:1000000];
    [NSObject print:_md min:0 classes:nil];
    [NSObject getCounter:_md];
    
    static const void *key = &key;
    static const void *key1 = &key1;
    
    SEL selector = NSSelectorFromString(@"dealloc");
    RSSwizzleInstanceMethod([NSObject class],
                            selector,
                            RSSWReturnType(void),
                            RSSWArguments(),
                            RSSWReplacement(
                                            {
                                                [NSObject setCounter:-1 :NSStringFromClass([self class]) :0 :_md];
                                                RSSWCallOriginal();
                                            }), RSSwizzleModeOncePerClassAndSuperclasses, key);
    SEL selector1 = NSSelectorFromString(@"init");
    RSSwizzleInstanceMethod([NSObject class],
                            selector1,
                            RSSWReturnType(id),
                            RSSWArguments(),
                            RSSWReplacement(
                                            {
                                                [NSObject setCounter:+1 :NSStringFromClass([self class]) :0 :_md];
                                                return RSSWCallOriginal();
                                            }), RSSwizzleModeOncePerClassAndSuperclasses, key1);
}

+ (NSInteger)getCounter:(NSMutableDictionary *)_md {
    static NSMutableDictionary *md = nil;
    if (md == nil) {
        md = _md;
    }
    __block NSInteger counter = 0;
    [md enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        counter = counter + [obj integerValue];
    }];
    return counter;
}

+ (NSInteger)getCounter {
    return [NSObject getCounter:nil];
}

+ (void)print {
    [NSObject print:nil min:0 classes:nil];
}

+ (void)printWithClasses:(NSArray*)classes {
    [NSObject print:nil min:2 classes:classes];
}

+ (void)print:(NSMutableDictionary *)_md min:(NSInteger)min classes:(NSArray*)classes {
    static NSMutableDictionary *md = nil;
    if (md == nil) {
        md = _md;
    } else {
        [md enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj integerValue] >= min && (classes == nil ||([classes containsObject:key]))) {
                NSLog(@"%@: [%@]", key, obj);
            }
        }];
    }
}

+ (id)setCounter:(NSInteger)_num :(NSString *)_class :(NSInteger)_op :(NSMutableDictionary *)_md {
    NSNumber *number = [_md objectForKey:_class];
    [_md setObject:@(number.integerValue + _num > 0 ?:0) forKey:_class];
    switch (_op) {
        case 0:
            return _md;
        default:
            return @(0);
            break;
    }
}


@end
