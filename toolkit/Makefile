CC=clang
CFLAGS=-Wall -g -o0 -fobjc-arc
OBJS=main.o root_patch.o render.o render_interface.o
MODULES=HTML5.dylib

toolkit: $(OBJS)
	make render_modules
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

%.o: %.m
	$(CC) $(CFLAGS) $(OBJCFLAGS) -o $@ -c $<

%.dylib: %.o
	$(CC) $(CFLAGS) -dynamiclib -o $@ $<

render_modules: $(MODULES)

.PHONY: render_modules