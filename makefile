GCC := g++

CFLAGS := -pthread -I./re2 -O3 -DNDEBUG -DKXVER=3 -Wall -Wextra
CFLAGS_64 := -m64
CFLAGS_L := -shared -fPIC -static-libstdc++

build: clean update_re2 build_re2a build_re2

update_re2:
	git submodule init
	git submodule update

build_re2a:
	cd re2 && make clean && make CXXFLAGS="-m64 -O3 -fPIC" LDFLAGS="-m64"

build_re2:
	$(GCC) $(CFLAGS) $(CFLAGS_64) $(CFLAGS_L) cpp/re2.cpp re2/obj/libre2.a -o src/re2.so

clean:
	rm src/*.so

.PHONY: clean update_re2 build_re2a build_re2
