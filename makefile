ifndef ver
	ver := $(git describe --abbrev=0)
	ifeq (${ver},)
		ver := "0.0.0"
	endif
endif
ifeq ($(OS),Windows_NT)
	exe_extension := .exe
	rmdir := rmdir -Recurse -Force
else
	exe_extension := 
	rmdir := rm -rf
endif
ifeq ($(filter test-module, $(MAKECMDGOALS)), "test-module")
	test-modules = 1
endif


full: init build-dev
clean: 
	git submodule deinit --all -f
	- $(rmdir) bin
init:
	git submodule init
	git pull --recurse-submodules
	cd .haxelib/hxcpp/git/tools/hxcpp && haxe compile.hxml
fresh: clean init build-dev
build-dev:
	haxe compile.hxml -cpp bin/dev -D version=${ver} -D WXSTATIC -D ABI=-MD
build-prod:
	haxe compile.hxml -D no-traces -cpp bin/prod
test:
	bin/dev/Main$(exe_extension)
test-jar-reader:
	haxe --interp -cp src --main Test -D test_jar_reader --resource src/assets/img/missingtex.png@missingtex