// Written by Elisa Silva, 2021-09-01
#import "render.h"
#import <dlfcn.h>

@implementation Renderer: NSObject

- (instancetype)init {
  self = [super init];
  if(self) {
      [self setSkeletonExtension: @".skeleton"];
      [self setSymbols:[[NSMutableDictionary alloc] init]];
  }

  return self;
}

- (void)addModuleAt:(NSString *)path {
    void *lib = dlopen([path cStringUsingEncoding:NSUTF8StringEncoding], RTLD_LAZY);
    if(lib == NULL) {
        NSLog(@"Could not load library %@\n", path);
        return;
    }
    
    DynamicParserVersion *version = dlsym(lib, "dynamicParserVersion");
    DynamicParserRegister *nameReg = dlsym(lib, "dynamicParserRegister");
    DynamicParserHandler *handler = dlsym(lib, "dynamicParserHandler");
    
    if(version() != 1) {
        dlclose(lib);
        return;
    }
    
    NSString *name = nameReg();
    [[self symbols] setValue: ^void * (BOOL second){
        if(second) return lib;
        return handler;
    } forKey:name];
}

- (void)renderPagesAt:(NSString *)folder to:(NSString *)renderedFolder {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSString *> *contents = [fileManager contentsOfDirectoryAtPath:folder error:nil];
    for(NSString *item in contents) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", folder, item];
        BOOL directory;
        if([fileManager fileExistsAtPath:path isDirectory:&directory]) {
            if(!directory && [item hasSuffix:@".skeleton"]) {
                NSData *data = [fileManager contentsAtPath:path];
                
                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSString *renderTarget = [NSString stringWithFormat:@"%@/%@%@", renderedFolder, [item stringByDeletingPathExtension], @".html"];
                
                [self render:object to:renderTarget];
            }
        }
    }
}

- (void)render:(id)object to:(NSString *)target {
    [[self recursiveRenderOf:object] writeToFile:target atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)recursiveRenderOf:(id)object {
    if([object isKindOfClass: [NSDictionary class]]) {
        NSDictionary *dic = object;
        NSString *fvalue = [dic valueForKey:@"f"];
        if(fvalue != nil) {
            Pair fpair = [[self symbols] valueForKey:fvalue];
            if(fpair != nil) {
                return ((DynamicParserHandler *) fpair(NO))(self, object);
            }
        }
    }
    return @"NOTREADY";
}

- (void)dealloc {
    for(NSString * key in [self symbols]) {
        Pair pair = [[self symbols] valueForKey:key];
        dlclose(pair(YES));
    }
}

@end
