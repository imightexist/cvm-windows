@echo off
title Starting script
md cvm
cd cvm
title Downloading Server
md server
cd server
powershell -Command "Invoke-WebRequest http://amogus.uk/public/without_folder/collab-vm-server-win64-jpeg-amd64.7z -OutFile server.7z"
cd..
title Downloading Webapp
md webapp
cd webapp
powershell -Command "Invoke-WebRequest https://codeload.github.com/computernewb/collab-vm-web-app/zip/refs/heads/master -OutFile webapp.zip"
cd..
title Downloading Node
md node
cd node
powershell -Command "Invoke-WebRequest https://nodejs.org/dist/v16.13.0/node-v16.13.0-win-x64.zip -OutFile node.zip"
cd..
title Downloading 7-zip
cd server
powershell -Command "Invoke-WebRequest http://amogus.uk/public2/7zipcommandonly/7z.exe -OutFile 7z.exe"
powershell -Command "Invoke-WebRequest http://amogus.uk/public2/7zipcommandonly/7z.dll -OutFile 7z.dll"
cd..
cd webapp
powershell -Command "Invoke-WebRequest http://amogus.uk/public2/7zipcommandonly/7z.exe -OutFile 7z.exe"
powershell -Command "Invoke-WebRequest http://amogus.uk/public2/7zipcommandonly/7z.dll -OutFile 7z.dll"
cd..
cd node
powershell -Command "Invoke-WebRequest http://amogus.uk/public2/7zipcommandonly/7z.exe -OutFile 7z.exe"
powershell -Command "Invoke-WebRequest http://amogus.uk/public2/7zipcommandonly/7z.dll -OutFile 7z.dll"
cd..
title Extracting Files
cd server
7z x server.7z -y
cd..
cd webapp
7z x webapp.zip -y
cd..
cd node
7z x node.zip -y
cd..
title Compiling webapp
cd node\node-v16.13.0-win-x64
set node=%cd%
call npm install --global npm
call npm install --global gulp-cli
cd..\..
cd webapp\collab-vm-web-app-master
call "%node%\npm.cmd" install
call "%node%\gulp.cmd"
title Copying files
cd build
copy *.* ..\..\..\server\win64\http\*.* /Y
cd ..\..\..
title Creating desktop shortcut
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo "%cd%\server\win64\collab-vm-server.exe" 6004 > startserver.bat
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\CollabVM Server.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%cd%\startserver.bat" >> %SCRIPT%
echo oLink.Arguments = "-h ServerNameOrIP -a ifix" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
title Done.
echo Script has finished, run "%cd%\server\win64\collab-vm-server.exe 6004" to start server. There is also a shortcut on your desktop.
set /p runserver=Do you want to start the server? (Y/N) 
if %runserver% == Y "%cd%\server\win64\collab-vm-server.exe" 6004
if %runserver% == y "%cd%\server\win64\collab-vm-server.exe" 6004
if %runserver% == N exit
if %runserver% == n exit
