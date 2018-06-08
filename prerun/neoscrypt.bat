REM This file will run for any algo if AlgoName.bat does not exist
REM Place your code below and rename this file to default.bat

echo prerun default file

REM Example clock settings using nvidiaInspector update nvidiaInspector.exe path accordingly or place it in prerun directory
REM !!! USE OC WITH CAUTION !!!

nvidiaInspector.exe -setPowerTarget:0,60
nvidiaInspector.exe -setPowerTarget:1,60
nvidiaInspector.exe -setPowerTarget:2,60
nvidiaInspector.exe -setPowerTarget:3,60
nvidiaInspector.exe -setPowerTarget:4,60
nvidiaInspector.exe -setPowerTarget:5,60