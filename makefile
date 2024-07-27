ifndef ver
	ver := $(git describe --abbrev=0)
	ifeq (${ver},)
		ver := "0.0.0"
	endif
endif

full: init build-dev
clean: 
	git submodule deinit --all -f
	rm -rf bin
init:
	git submodule init
	git pull --recurse-submodules
	cd .haxelib/hxcpp/git/tools/hxcpp;\
	haxe compile.hxml;
build-dev:
	haxe compile.hxml -cpp bin/dev -D version=${ver}
build-prod:
	haxe compile.hxml -D no-traces -cpp bin/prod
test:
	bin/dev/Main