ifndef ver
	ver := $(git describe --abbrev=0)
	ifeq (${ver},)
		ver := "0.0.0"
	endif
endif
ifeq ($(OS),Windows_NT)
	exe_extension := .exe
	script_extension := .bat
	script_prefix := .\\
	rmdir := rmdir -Recurse -Force
	move := Move-Item -Force
else
	exe_extension := 
	script_extension := 
	script_prefix := ./
	rmdir := rm -rf
	move := mv -f
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
reinit: clean init
fresh: clean init build-dev
build-dev: build-mod
	haxe compile.hxml -cpp bin/dev -D version=${ver}
build-prod: build-mod
	haxe compile.hxml -D no-traces -cpp bin/prod -D version=${ver}
build-mod:
	cd mod &&\
	$(script_prefix)gradlew$(script_extension) build &&\
	$(move) build/libs/cartographersmod*.jar ../src/assets/pkg/cartographersmod.jar
test:
	bin/dev/Main$(exe_extension)
test-jar-reader:
	haxe --interp -cp src --main Test -D test_jar_reader
test-dumper:
	haxe --interp -cp src --main Test -D test_dumper --resource src/assets/pkg/cartographersmod.jar@modjar