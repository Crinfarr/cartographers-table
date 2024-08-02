ifndef ver
	ver := $(git describe --abbrev=0)
	ifeq (${ver},)
		ver := "0.0.0"
	endif
endif
ifeq ($(filter test-module, $(MAKECMDGOALS)), "test-module")
	test-modules = 1
endif


full: init build-dev
clean: 
	git submodule deinit --all -f
	ifeq ($(OS),Windows_NT)
		- rmdir -Recurse -Force bin
	else
		- rm -rf bin
	endif
init:
	git submodule init
	git pull --recurse-submodules
	cd .haxelib/hxcpp/git/tools/hxcpp && haxe compile.hxml
reinit: clean init
fresh: clean init build-dev
build-dev:
	haxe compile.hxml -cpp bin/dev -D version=${ver}
build-prod: build-mod
	haxe compile.hxml -D no-traces -cpp bin/prod -D version=${ver}
build-mod:
	ifeq ($(OS),Windows_NT)
		cd mod &&\
		.\\gradlew.bat build &&\
		Move-Item -Force build/libs/cartographersmod*.jar ../src/assets/pkg/cartographersmod.jar
	else
		cd mod &&\
		./gradlew build &&\
		mv -f build/libs/cartographersmod*.jar ../src/assets/pkg/cartographersmod.jar
	endif
test:
	ifeq ($(OS),Windows_NT)
		bin/dev/Main.exe
	else
		bin/dev/Main
	endif
test-jar-reader:
	haxe --interp -cp src --main Test -D test_jar_reader
test-dumper:
	haxe --interp -cp src --main Test -D test_dumper --resource src/assets/pkg/cartographersmod.jar@modjar