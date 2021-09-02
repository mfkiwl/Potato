// Written by Elisa Silva, 2021-09-01
#pragma once

#import <Foundation/Foundation.h>

typedef void * (^Pair) (BOOL);

@interface Renderer: NSObject

@property NSString *skeletonExtension;
@property NSMutableDictionary<NSString *, Pair> *symbols;

- (void)addModuleAt:(NSString *)path;
- (void)renderPagesAt:(NSString *)folder to:(NSString *)renderedFolder;
- (NSString *)recursiveRenderOf:(id)object;
- (void)dealloc;

@end

typedef NSString *DynamicParserHandler(Renderer * r, id object);
typedef NSString *DynamicParserRegister(void);
typedef NSUInteger DynamicParserVersion(void);
