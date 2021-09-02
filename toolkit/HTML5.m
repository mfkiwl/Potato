// Written by Elisa Silva, 2021-09-01
#import "render.h"

NSString *dynamicParserHandler(Renderer * r, id object) {
    NSDictionary<NSString *, id> *dictionary = object;
    NSString *htmlParams = [dictionary valueForKey:@"a"];
    if(htmlParams == nil) htmlParams = @"";
    
    NSMutableDictionary *head = [[NSMutableDictionary alloc] init];
    [head setValue:@"head" forKey:@"t"];
    [head setValue:[dictionary valueForKey:@"h"] forKey:@"i"];
    
    NSMutableDictionary *body;
    [body setValue:@"body" forKey:@"t"];
    [body setValue:[dictionary valueForKey:@"b"] forKey:@"i"];
    
    return [NSString stringWithFormat:@"<!DOCTYPE html><html %@>%@%@</html>", htmlParams, [r recursiveRenderOf:head], [r recursiveRenderOf:body]];
}

NSString *dynamicParserRegister(void) {
    return @"HTML5";
}

NSUInteger dynamicParserVersion(void) {
    return 1;
}
