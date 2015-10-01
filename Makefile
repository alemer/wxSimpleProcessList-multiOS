# wxWidget-test project.
# 1. Download the neccessary tools at http://alemer.de/source_tools/source_tools
OUTFILENAME = wxHelloWorld

# Define our sources, calculate the dependecy files and object files
TEST_SOURCES := src/wxHelloWorld.cpp 
TEST_OBJECTS := $(patsubst %.cpp, %.o, ${TEST_SOURCES})
TEST_DEPS := $(patsubst %.cpp, %.d, ${TEST_SOURCES})	

#include our project dependecy files
#-include $(TEST_DEPS)
	
INCFLAGS = -I./include
CXXFLAGS = --cxxflags
CXX      = --cxx
LDFLAGS  = --ldflags
LDLIBS   = --libs
REZFLAGS = --rez-flags

	
ifdef win32
	@echo "Defined win32 as target - Building"; 
	OS = "win32";
endif

linux: linPrep linPath
	@echo "Defined linux as target - Building ... "; 
	$(eval WXOUTPUT=./output/linux/$(OUTFILENAME))
	$(eval WXCONFIG=./wx-config-linux)
	$(eval WXPREFIX=./tools/wxWidgets-3.0.2-x86_64_pc_linux)
	`$(WXCONFIG) --prefix=$(WXPREFIX) $(CXX) $(CXXFLAGS) $(LDLIBS) $(INCFLAGS)` $(TEST_SOURCES) -o $(WXOUTPUT)

win64: win32
	@echo "Building win32 verstion thou defined win64 as target - Building"
	@echo "Please use build executable located ./output/win32/$(wxHelloWorld).exe"
#	@echo "Defined win64 as target - Building"; 
#	$(eval HOST=x86_64-mingw32)
#	$(eval GCCWINPATH=./tools/gcc-5.1.0-x86_64-mingw32/bin)
#	$(eval WXOUTPUT=./output/win64/$(OUTFILENAME).exe)
#	$(eval WXCONFIG=./wx-config-mingw32)
#	$(eval WXPREFIX=./tools/wxWidgets-3.0.2-i686-pc-mingw32)
#	$(eval WXWINPATH=$(WXPREFIX)/bin)
#	$(eval WININCFLAGS=-I./tools/wxWidgets-3.0.2-i686-pc-mingw32/lib/wx/include/i686-pc-mingw32-msw-unicode-3.0)
#	$(eval WINLDFLAGS="-L$(GCCWINPATH)/../lib -L$(WXPREFIX)/lib" -L$(GCCWINPATH)/../lib -lwx_mswu-3.0-i686-pc-mingw32.dll)
#	$(eval export PATH=$(GCCWINPATH):$(WXWINPATH):${PATH})
#	$(HOST)-gcc $(WININCFLAGS) `$(WXCONFIG) --prefix=$(WXPREFIX) --exec-prefix=$(GCCWINPATH) --rescomp $(CXXFLAGS) $(LDLIBS) $(INCFLAGS)` $(TEST_SOURCES) -o $(WXOUTPUT) -Wl,$(WINLDFLAGS)

win32: win32Prep win32Path
	@echo "Defined win32 as target - Building"; 
	$(eval HOST=i686-pc-mingw32)
	$(eval GCCWINPATH=./tools/gcc-5.1.0-i686-mingw32/bin)
	$(eval WXOUTPUT=./output/win32/$(OUTFILENAME).exe)
	$(eval WXCONFIG=./wx-config-mingw32)
	$(eval WXPREFIX=./tools/wxWidgets-3.0.2-i686-pc-mingw32)
	$(eval WXWINPATH=$(WXPREFIX)/bin)
	$(eval WINLDFLAGS="-L./tools/$(WXPREFIX)/lib" -lwx_mswu-3.0-i686-pc-mingw32.dll)
	$(eval export PATH=$(GCCWINPATH):$(WXWINPATH):${PATH})
	`$(WXCONFIG) --prefix=$(WXPREFIX) $(CXX) $(CXXFLAGS) $(LDLIBS) $(INCFLAGS) --host=$(HOST)` $(TEST_SOURCES) -o $(WXOUTPUT) -Wl,$(WINLDFLAGS)

	
all: 
	@echo "Use one of the target definitions: win32, win64, linux";
	@echo "'make win32' 		- Builds the executable for 32Bit Windows ";
	@echo "'make linux' 		- Builds the executable for linux. You need to habe gcc installed ";
	@echo "'make win64' 		- Builds the executable for 64Bit Windows ";
	@echo "'make clean' 		- Deletes all objects and created executables";
	@echo "'make clean' 		- Deletes all objects and created executables";
	@echo "'make tools' 		- Download and initalizes wxWidget and GCC toolchain";
	@echo "'make cleanTools' 	- Deletes the toolchain";
	exit 0;	

tools: wget tar links

wget: 
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/gcc-5.1.0-i686-mingw32.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/gcc-5.1.0-x86_64-mingw32.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/wxWidgets-3.0.2-i686-pc-mingw32.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/wxWidgets-3.0.2-x86_64_pc_linux.tar.gz;
	
tar:
	tar --directory=./tools -xf ./tools/gcc-5.1.0-i686-mingw32.tar.gz;
	tar --directory=./tools -xf ./tools/gcc-5.1.0-x86_64-mingw32.tar.gz;
	tar --directory=./tools -xf ./tools/wxWidgets-3.0.2-i686-pc-mingw32.tar.gz;
	tar --directory=./tools -xf ./tools/wxWidgets-3.0.2-x86_64_pc_linux.tar.gz;
	
links:
	ln -s tools/wxWidgets-3.0.2-x86_64_pc_linux/lib64/wx/config/gtk2-unicode-3.0 wx-config-linux;
	ln -s tools/wxWidgets-3.0.2-i686-pc-mingw32/lib/wx/config/i686-pc-mingw32-msw-unicode-3.0 wx-config-mingw32;

	
linPrep:
	mkdir -p output/linux
	
win64Prep:
	mkdir -p output/win64
	
win32Prep:
	mkdir -p output/win32

win64Path:

win32Path:

linPath:
	@echo "Adjust LD_LIBRARY_PATH befor execution"
	@echo 'export LD_LIBRARY_PATH=./tools/wxWidgets-3.0.2-x86_64_pc_linux/lib64:\$\LD_LIBRARY_PATH'

clean:
	rm -f `find src/ -iname ".o"` 
	rm -f `find output/ -iname "$(OUTFILENAME)*"`
	
cleanTools:
	rm -rf ./toools/*

test: $(TEST_OBJECTS)
	$(CXX) $(LDFLAGS) -o test $(TEST_OBJECTS) Test_resources.o $(LDLIBS)
ifdef FINAL
        strip test
endif
