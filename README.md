# wxWidget-test-project
Crosscompile Toolchain for Windows x86_64, x86 gcc and wxWidgets for Windows and Linux and Hello World test source. Goto to alemer.de for aditional explanations.

This Crosscompile toolchain is design for HOST Linux x86_64 architecture and 
generated output for TARGET Linux (x86_64_pc_linux), Windows (i686-mingw32, x86_64-mingw32)

Checkout git project with 
git clone https://github.com/alemer/wxWidget-test-project.git
cd wxWidget-test-project/tools

1. Download the Crosscompile toolchain neccessary for you into tools
	wget -c http://alemer.de/source_tools/source_tools/gcc-5.1.0-i686-mingw32.tar.gz
	wget -c http://alemer.de/source_tools/source_tools/gcc-5.1.0-x86_64-mingw32.tar.gz
	wget -c http://alemer.de/source_tools/source_tools/wxWidgets-3.0.2-i686-pc-mingw32.tar.gz
	wget -c http://alemer.de/source_tools/source_tools/wxWidgets-3.0.2-x86_64_pc_linux.tar.gz

2. Extract the toolchain into ./tools
	tar -xf gcc-5.1.0-i686-mingw32.tar.gz
	tar -xf gcc-5.1.0-x86_64-mingw32.tar.gz
	tar -xf wxWidgets-3.0.2-i686-pc-mingw32.tar.gz
	tar -xf wxWidgets-3.0.2-x86_64_pc_linux.tar.gz
	
	So the links wxWidget-config-linux and wxWidget-config-mingw32 will work.
	
3. cd ..
	Now the the project can be build for Linux
	`./wx-config-linux --prefix=./tools/wxwidgets-3.0.2-x86_64_linux --cxx --cxxflags --libs` src/wxHelloWorld.cpp -o output/linux/wxHalloWorld
	
	For Windows:
	`./wx-config-mingw32 --prefix=./tools/wxWidgets-i686-pc-mingw32 --cxx --cxxflags --libs --host=i686-pc-mingw32` src/wxHelloWorld.cpp -o output/win32/wxHelloWorld.exe -Wl,"-L./tools/wxWidgets-i686-pc-mingw32/lib -lwx_mswu-3.0-i686-pc-mingw32.dll" -lwx_mswu-3.0-i686-pc-mingw32.dll
	
	