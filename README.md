# wxSimpleProcessList-multiOS
This contains the simple process list by pID, proccessname and Username for linux, win, win64, win64_static.
For windows build the easiest way is to call `make tools && make win64_static` which will generate a statically build application.

Crosscompile Toolchain for Windows x86_64, x86 gcc and wxWidgets for Windows and Linux. Goto to alemer.de for aditional explanations.

This Crosscompile toolchain is design for HOST Linux x86_64 architecture and 
generated output for TARGET Linux (x86_64_pc_linux), Windows (i686-mingw32, x86_64-mingw32)

Checkout git project with 
git clone https://github.com/alemer/wxSimpleProcessList-multiOS.git

TODO: 	Makefile 

Use one of the target definitions: win32, win64, linux
First call 'make tools' for the toolchain initialization

'make win32'            - Builds the executable for 32Bit Windows 

'make win64'            - Builds the executable for 64Bit Windows 

'make win64_static'     - Builds the executable for Static 64Bit Windows 

'make linux'            - Builds the executable for linux. You need to have gcc toolchain installed 

'make clean'            - Deletes all objects and created executables

'make tools'            - Download and initalizes wxWidget dev environment and GCC mingw win32 toolchain

NOTE                   - You will have to install the dev toolchain for you Linux System youself (gcc, binutils ...)

'make cleanTools'       - Deletes the toolchain

