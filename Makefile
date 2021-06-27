unix : u10 u11 u20

mac : m10 m11 m20

lib/libtestld.so : lib.c
	$(CC) -DVERSION='"1.0"' -shared -fPIC -o $@ $?
lib10/libtestld.so : lib.c
	$(CC) -DVERSION='"1.0"' -shared -fPIC -Wl,-soname,libtestld.so.1.0 -o $@ $?
lib11/libtestld.so : lib.c
	$(CC) -DVERSION='"1.1"' -shared -fPIC -Wl,-soname,libtestld.so.1.1 -o $@ $?
lib20/libtestld.so : lib.c
	$(CC) -DVERSION='"2.0"' -shared -fPIC -Wl,-soname,libtestld.so.2.0 -o $@ $?

jumble/libtestld.so.1.0 : lib10/libtestld.so
	cp -f $? $@
jumble/libtestld.so.1.1 : lib11/libtestld.so
	cp -f $? $@
jumble/libtestld.so.2.0 : lib20/libtestld.so
	cp -f $? $@

lib/libtestld.dylib : lib.c
	$(CC) -DVERSION='"1.0"' -fPIC -Wl,-dylib -o $@ $?
lib10/libtestld.dylib : lib.c
	$(CC) -DVERSION='"1.0"' -fPIC -Wl,-dylib -Wl,-install_name,libtestld.1.dylib -Wl,-current_version,1.0.0 -Wl,-compatibility_version,1.0.0 -o $@ $?
lib11/libtestld.dylib : lib.c
	$(CC) -DVERSION='"1.1"' -fPIC -dynamiclib -install_name libtestld.1.dylib -current_version 1.1.0 -compatibility_version 1.1.0 -o $@ $?
lib20/libtestld.dylib : lib.c
	$(CC) -DVERSION='"2.0"' -fPIC -dynamiclib -install_name libtestld.2.dylib -current_version 2.0.0 -compatibility_version 2.0.0 -o $@ $?

jumble/libtestld.1.dylib : lib11/libtestld.dylib
	cp -f $? $@
jumble/libtestld.2.dylib : lib20/libtestld.dylib
	cp -f $? $@

u : use.c lib/libtestld.so
	$(CC) -Llib -o $@ use.c -ltestld
u10 : use.c lib10/libtestld.so
	$(CC) -Llib10 -o $@ use.c -ltestld
u11 : use.c lib11/libtestld.so
	$(CC) -Llib11 -o $@ use.c -ltestld
u20 : use.c lib20/libtestld.so
	$(CC) -Llib20 -o $@ use.c -ltestld

m : use.c lib/libtestld.dylib
	$(CC) -Llib -o $@ use.c -ltestld
m10 : use.c lib10/libtestld.dylib
	$(CC) -Llib10 -o $@ use.c -ltestld
m11 : use.c lib11/libtestld.dylib
	$(CC) -Llib11 -o $@ use.c -ltestld
m20 : use.c lib20/libtestld.dylib
	$(CC) -Llib20 -o $@ use.c -ltestld

j : use.c jumble/libtestld.so.1.0 jumble/libtestld.so.1.1 jumble/libtestld.so.2.0
	$(CC) -Ljumble -o $@ use.c -ltestld

j10 : use.c jumble/libtestld.so.1.0 jumble/libtestld.so.1.1 jumble/libtestld.so.2.0
	$(CC) -Ljumble -o $@ use.c -l:libtestld.so.1.0

mj : use.c jumble/libtestld.1.dylib jumble/libtestld.2.dylib
	$(CC) -Ljumble -o $@ use.c -ltestld

mj1 : use.c jumble/libtestld.1.dylib jumble/libtestld.2.dylib
	$(CC) -Ljumble -o $@ use.c -l:libtestld.1.dylib

install-unix :
	cp lib10/libtestld.so /usr/local/lib/libtestld.so.1.0
	cp lib11/libtestld.so /usr/local/lib/libtestld.so.1.1
	cp lib20/libtestld.so /usr/local/lib/libtestld.so.2.0

install-mac :
	cp lib10/libtestld.dylib /usr/local/lib/libtestld.1.dylib
	cp lib20/libtestld.dylib /usr/local/lib/libtestld.2.dylib

clean :
	rm -f lib??/*
	rm -f m?? u??
