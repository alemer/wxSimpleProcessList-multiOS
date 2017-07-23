# wxWidget-test project.
# 1. Download the neccessary tools at http://alemer.de/source_tools/what_ever.tar.gz
OUTFILENAME = prozShow

# Define our sources, calculate the dependecy files and object files
TEST_SOURCES := src/wxProzShow.cpp 
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

help: all

linux: linPrep linPath
	@echo "Defined linux as target - Building ... "; 
	$(eval WXOUTPUT=./output/linux/$(OUTFILENAME))
	$(eval WXCONFIG=./wx-config-linux)
	$(eval WXPREFIX=./tools/wxWidgets-3.0.2-x86_64_linux)
	`$(WXCONFIG) --prefix=$(WXPREFIX) $(CXX) $(CXXFLAGS) $(LDLIBS) $(INCFLAGS)` $(INCFLAGS) -I/usr/include -I./$(WXPREFIX)/lib64/wx/include -I./$(WXPREFIX)/include -D__LINUX_DYNAMIC__ $(TEST_SOURCES) -o $(WXOUTPUT)

win64_static: win64Prep_static win64Path
	@echo "Defined win64 Static as target - Building";
	$(eval HOST=x86_64-pc-mingw32)
	$(eval GCCWINPATH=./tools/gcc-5.1.0-${HOST}-static/bin)
	$(eval WXOUTPUT=./output/win64_static/$(OUTFILENAME).exe)
	$(eval WXCONFIG=./wx-config-${HOST}-static)
	$(eval WXPREFIX=./tools/wxWidgets-3.0.2-${HOST}_static)
	$(eval WXWINPATH=$(WXPREFIX)/$(HOST)/bin)
	$(eval WXLIBPATH=$(GCCWINPATH)/../$(HOST)/lib)
	$(eval WININCFLAGS=-I./$(WXPREFIX)/lib64/wx/include -I./$(WXPREFIX)/include -I$(GCCWINPATH)/../include) 
	$(eval WINLDFLAGS=-L$(GCCWINPATH)/../lib64 -L$(WXPREFIX)/lib64 -lstdc++.dll -lstdc++ -lpsapi)
	$(eval export PATH=$(GCCWINPATH):$(WXWINPATH):${PATH})
	`$(WXCONFIG) --prefix=$(WXPREFIX) $(CXX) --static=yes --host=$(HOST)` $(INCFLAGS) -D__WIN64_STATIC__ $(TEST_SOURCES) -o $(WXOUTPUT) `$(WXCONFIG) --prefix=$(WXPREFIX) $(CXXFLAGS) $(LDLIBS) --static=yes --host=$(HOST)` $(WINLDFLAGS)
	cp ${WXLIBPATH}/libgcc_s_seh-1.dll ${WXLIBPATH}/libstdc++-6.dll ./output/win64_static

win64: win64Prep win64Path
	@echo "Defined win64 as target - Building"; 
	$(eval HOST=x86_64-pc-mingw32)
	$(eval GCCWINPATH=./tools/gcc-5.1.0-${HOST}/bin)
	$(eval WXOUTPUT=./output/win64/$(OUTFILENAME).exe)
	$(eval WXCONFIG=./wx-config-${HOST})
	$(eval WXPREFIX=./tools/wxWidgets-3.0.2-${HOST})
	$(eval WXWINPATH=$(WXPREFIX)/bin)
	$(eval WXLIBPATH=$(GCCWINPATH)/../lib)
	$(eval WININCFLAGS=-I./$(WXPREFIX)/lib64/wx/include -I./$(WXPREFIX)/include -I$(GCCWINPATH)/../include) 
	$(eval WINLDFLAGS=-L$(GCCWINPATH)/../lib64 -L$(WXPREFIX)/lib64 -lstdc++.dll -lstdc++ -lpsapi)
	$(eval export PATH=$(GCCWINPATH):$(WXWINPATH):${PATH})
	`$(WXCONFIG) --prefix=$(WXPREFIX) $(CXX) --static=no --host=$(HOST)` $(INCFLAGS) -D__WIN64_DYNAMIC__ $(TEST_SOURCES) -o $(WXOUTPUT) `$(WXCONFIG) --prefix=$(WXPREFIX) $(CXXFLAGS) $(LDLIBS) --static=no --host=$(HOST)` $(WINLDFLAGS)
	cp ${WXLIBPATH}/libgcc_s_seh-1.dll ${WXLIBPATH}/libstdc++-6.dll ./output/win64
	cp ${WXWINPATH}/../lib/wxmsw30u_core_gcc_custom.dll ./output/win64
	cp ${WXWINPATH}/../lib/wxmsw30u_adv_gcc_custom.dll ./output/win64
	cp ${WXWINPATH}/../lib/wxbase30u_gcc_custom.dll ./output/win64

win32: win32Prep win32Path
	@echo "Defined win32 as target - Building"; 
	$(eval HOST=i686-pc-mingw32)
	$(eval GCCWINPATH=./tools/gcc-5.1.0-i686-mingw32/bin)
	$(eval WXOUTPUT=./output/win32/$(OUTFILENAME).exe)
	$(eval WXCONFIG=./wx-config-${HOST})
	$(eval WXPREFIX=./tools/wxWidgets-3.0.2-${HOST})
	$(eval WXWINPATH=$(WXPREFIX)/bin)
	$(eval WXLIBPATH=$(GCCWINPATH)/../lib)
	$(eval WINLDFLAGS="-L$(WXPREFIX)/lib" -lwx_mswu-3.0-${HOST}.dll -lstdc++.dll -lstdc++ -lpsapi)
	$(eval export PATH=$(GCCWINPATH):$(WXWINPATH):${PATH})
	`$(WXCONFIG) --prefix=$(WXPREFIX) $(CXX) --static=no --host=$(HOST)` $(INCFLAGS) -D__WIN32_DYNAMIC__ $(TEST_SOURCES) -o $(WXOUTPUT) `$(WXCONFIG) --prefix=$(WXPREFIX) $(CXXFLAGS) $(LDLIBS) --static=no --host=$(HOST)` $(WINLDFLAGS)
	cp ${WXLIBPATH}/libgcc_s_sjlj-1.dll ${WXLIBPATH}/libstdc++-6.dll ./output/win32
	cp ${WXWINPATH}/../lib/wxmsw30u_core_gcc_custom.dll ./output/win32
	cp ${WXWINPATH}/../lib/wxmsw30u_adv_gcc_custom.dll ./output/win32
	cp ${WXWINPATH}/../lib/wxbase30u_gcc_custom.dll ./output/win32
	
all: 
	@echo "Use one of the target definitions: win32, win64, linux";
	@echo "First call 'make tools' for the toolchain initialization";
	@echo "'make win32' 		- Builds the executable for 32Bit Windows ";
	@echo "'make win64' 		- Builds the executable for 64Bit Windows ";
	@echo "'make win64_static' 	- Builds the executable for Static 64Bit Windows ";
	@echo "'make linux'         	- Builds the executable for linux. You need to have gcc toolchain installed ";
	@echo "'make clean' 		- Deletes all objects and created executables";
	@echo "'make tools' 		- Download and initalizes wxWidget dev environment and GCC mingw win32 toolchain";
	@echo " NOTE 			- You will have to install the dev toolchain for you Linux System youself (gcc, binutils ...)";
	@echo "'make cleanTools' 	- Deletes the toolchain";
	exit 0;	

tools: wget tar links clean_targz

wget: 
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/gcc-5.1.0-i686-mingw32.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/gcc-5.1.0-x86_64-pc-mingw32-static.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/gcc-5.1.0-x86_64-pc-mingw32.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/wxWidgets-3.0.2-i686-pc-mingw32.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/wxWidgets-3.0.2-x86_64-pc-mingw32.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/wxWidgets-3.0.2-x86_64-pc-mingw32_static.tar.gz;
	wget --directory-prefix=./tools/ -c http://alemer.de/source_tools/wxWidgets-3.0.2-x86_64_linux.tar.gz;
	
tar:
	tar --directory=./tools -xf ./tools/gcc-5.1.0-i686-mingw32.tar.gz;
	tar --directory=./tools -xf ./tools/gcc-5.1.0-x86_64-pc-mingw32-static.tar.gz;
	tar --directory=./tools -xf ./tools/gcc-5.1.0-x86_64-pc-mingw32.tar.gz;
	tar --directory=./tools -xf ./tools/wxWidgets-3.0.2-i686-pc-mingw32.tar.gz;
	tar --directory=./tools -xf ./tools/wxWidgets-3.0.2-x86_64-pc-mingw32.tar.gz;
	tar --directory=./tools -xf ./tools/wxWidgets-3.0.2-x86_64-pc-mingw32_static.tar.gz;
	tar --directory=./tools -xf ./tools/wxWidgets-3.0.2-x86_64_linux.tar.gz;
	
links:
	ln -s tools/wxWidgets-3.0.2-i686-pc-mingw32/bin/wx-config wx-config-i686-pc-mingw32;
	ln -s tools/wxWidgets-3.0.2-i686-pc-mingw32/bin/wx-config-static wx-config-i686-pc-mingw32-static;
	ln -s tools/wxWidgets-3.0.2-x86_64-pc-mingw32/bin/wx-config wx-config-x86_64-pc-mingw32;
	ln -s tools/wxWidgets-3.0.2-x86_64-pc-mingw32_static/bin/wx-config wx-config-x86_64-pc-mingw32-static;
	ln -s tools/wxWidgets-3.0.2-x86_64_linux/bin/wx-config wx-config-linux;
	
linPrep:
	mkdir -p output/linux
	
	
win64Prep_static:
	mkdir -p output/win64_static
	
win32Prep_static:
	mkdir -p output/win32_static

win64Prep:
	mkdir -p output/win64
	
win32Prep:
	mkdir -p output/win32

win64Path:

win32Path:

linPath:
	@echo "Adjust LD_LIBRARY_PATH befor execution"
	@echo 'export LD_LIBRARY_PATH=./tools/wxWidgets-3.0.2-x86_64_linux/lib64:$LD_LIBRARY_PATH'

clean_targz:
	rm -rf tools/*.tar.gz
	
clean:
	rm -f `find src/ -iname ".o"` 
	rm -f `find output/ -iname "*$(OUTFILENAME)*"`
	rm -f `find output/ -iname "*.dll"`
	
cleanTools:
	rm -rf ./tools/* wx-config*

test: $(TEST_OBJECTS)
	$(CXX) $(LDFLAGS) -o test $(TEST_OBJECTS) Test_resources.o $(LDLIBS)
ifdef FINAL
        strip test
endif
