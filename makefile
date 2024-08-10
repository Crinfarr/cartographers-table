ifndef ver
	ver := $(git describe --abbrev=0)
	ifeq (${ver},)
		ver := "0.0.0"
	endif
endif
ifeq ($(shell uname),WindowsNT)
	rmrf := rmdir -Recurse -Force
	mvf := Move-Item -Force
	exext := .exe
	scext := .bat
	preq := .\\
else
	rmrf := rm -rf
	mvf := mv -f
	exext := 
	scext := 
	preq := ./
endif


full: init build-dev
clean: 
	git submodule deinit --all -f
	- $(rmrf) bin
init:
	git submodule init
	git pull --recurse-submodules
	cd .haxelib/hxcpp/git/tools/hxcpp && haxe compile.hxml
reinit: clean init
fresh: clean init build-dev
build-dev:
	haxe compile.hxml -cpp bin/dev -D version=${ver} -D DEVMODE
build-prod: build-mod
	haxe compile.hxml -D no-traces -cpp bin/prod -D version=${ver}
build-mod:
	cd mod &&\
	$(preq)gradlew$(scext) build &&\
	$(mvf) build/libs/cartographersmod*.jar ../src/assets/pkg/cartographersmod.jar
test:
	bin/dev/Main$(exext)
	
test-jar-reader:
	haxe --interp -cp src --main Test -D test_jar_reader
test-dumper:
	haxe --interp -cp src --main Test -D test_dumper --resource src/assets/pkg/cartographersmod.jar@modjar
test-mod-list:
	haxe --interp -cp src --main Test -D test_mod_list