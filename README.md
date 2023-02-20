# DllExporter
A script which uses dumpbin.exe to grab exports and generate pragma directives for DLL proxying.

Generate two files, a .def and a .txt file with the pragma directives. 

It adds "_original" to the end of the DLL as you will need it to be named differently.

You will need to edit the script to add the path of where your DumpBin.exe is. I didn't add it as a parameter as this is the default location for VS 2022.
