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
powershell -Command "Invoke-WebRequest https://nodejs.org/download/release/v13.14.0/node-v13.14.0-win-x64.zip -OutFile node.zip"
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
cd node\node-v13.14.0-win-x64
set node=%cd%
call npm config set strict-ssl false
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
echo cd /d "%cd%\server\win64" > startserver.bat
echo collab-vm-server.exe 6004 >> startserver.bat
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\CollabVM Server.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%cd%\startserver.bat" >> %SCRIPT%
echo oLink.Arguments = "-h ServerNameOrIP -a ifix" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo cd /d "%cd%\server\win64" > startserverwithlt.bat
start "%cd%\..\..\node\npx.cmd" localtunnel --port 6004 >> startserverwithlt.bat
collab-vm-server.exe 6004 >> startserverwithlt.bat
echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\CollabVM Server.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%cd%\startserverwithlt.bat" >> %SCRIPT%
echo oLink.Arguments = "-h ServerNameOrIP -a ifix" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del %SCRIPT%
title Done.
echo Script has finished, to start the server: cd "%cd%\server\win64" & collab-vm-server.exe 6004
echo If you want to use localtunnel for your server, run "%cd%\node\npx.cmd" localtunnel --port 6004
echo There is also a shortcut on your desktop.
goto runserver

:runserver
set /p runserver=Do you want to start the server? (Y/N/LT) 
if %runserver% == Y goto startserver
if %runserver% == y goto startserver
if %runserver% == LT goto startserverwithlt
if %runserver% == lt goto startserverwithlt
if %runserver% == lT goto startserverwithlt
if %runserver% == Lt goto startserverwithlt
if %runserver% == N exit
if %runserver% == n exit
goto runserver

:startserver
cd /d "%cd%\server\win64"
collab-vm-server.exe 6004
set /p tryagain=Server has closed, run again? (Y/N)
if %tryagain% == Y goto startserver
if %tryagain% == y goto startserver
if %tryagain% == N exit
if %tryagain% == n exit
exit

:startserverwithlt
cd /d "%cd%\server\win64"
start "%cd\..\..\node\npx.cmd" localtunnel --port 6004
collab-vm-server.exe 6004
exit
