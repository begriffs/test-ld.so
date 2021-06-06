all : use10 use11 use20

lib10/libtestld.so : lib.c
	$(CC) -DVERSION='"1.0"' -shared -fPIC -Wl,-soname,libtestld.so.1.0 -o $@ $?

lib11/libtestld.so : lib.c
	$(CC) -DVERSION='"1.1"' -shared -fPIC -Wl,-soname,libtestld.so.1.1 -o $@ $?

lib20/libtestld.so : lib.c
	$(CC) -DVERSION='"2.0"' -shared -fPIC -Wl,-soname,libtestld.so.2.0 -o $@ $?

use10 : use.c lib10/libtestld.so
	$(CC) -Llib10 -ltestld -o $@ use.c
use11 : use.c lib11/libtestld.so
	$(CC) -Llib11 -ltestld -o $@ use.c
use20 : use.c lib20/libtestld.so
	$(CC) -Llib20 -ltestld -o $@ use.c

install :
	cp lib10/libtestld.so /usr/local/lib/libtestld.so.1.0
	cp lib11/libtestld.so /usr/local/lib/libtestld.so.1.1
	cp lib20/libtestld.so /usr/local/lib/libtestld.so.2.0
