// Written by Elisa Silva, 2021-09-01
#import "render_interface.h"
#import "render.h"

void renderPages(void) {
    @autoreleasepool {
        Renderer *renderer = [[Renderer alloc] init];
        [renderer addModuleAt:@"toolkit/HTML5.dylib"];
        [renderer renderPagesAt:@"website" to:@"mac0499"];
    }
}
