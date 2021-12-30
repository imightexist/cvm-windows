@echo off
title Starting script
md cvm
cd cvm
title Checking Windows Version
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
title Downloading curl
if %version% == 10.0 goto win8download
if %version% == 6.3 goto win8download
if %version% == 6.2 goto win8download
if %version% == 6.1 goto win7download
echo Sorry your Windows version is not supported.
pause
exit

:start
title Downloading Server
md server
cd server
"%curl%" -Lk https://hfs-redirect.glitch.me/7zexe.html --output 7z.exe
"%curl%" -Lk https://hfs-redirect.glitch.me/7zdll.html --output 7z.dll
"%curl%" -Lk https://hfs-redirect.glitch.me/cvmserver.html --output server.7z
cd..
title Downloading Webapp
md webapp
cd webapp
"%curl%" -Lk https://hfs-redirect.glitch.me/7zexe.html --output 7z.exe
"%curl%" -Lk https://hfs-redirect.glitch.me/7zexe.html --output 7z.dll
"%curl%" -Lk https://codeload.github.com/computernewb/collab-vm-web-app/zip/refs/heads/master --output webapp.zip
cd..
title Downloading Node
md node
cd node
"%curl%" -Lk https://hfs-redirect.glitch.me/7zexe.html --output 7z.exe
"%curl%" -Lk https://hfs-redirect.glitch.me/7zexe.html --output 7z.dll
"%curl%" -0 https://nodejs.org/download/release/v13.14.0/node-v13.14.0-win-x64.zip --output node.zip
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
title Done.
echo Script has finished, to start the server: cd "%cd%\server\win64"
echo Then run: collab-vm-server.exe 6004
echo There is also a shortcut on your desktop.
goto runserver

:runserver
set /p runserver=Do you want to start the server? (Y/N) 
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
start %cd%\..\..\node\node-v13.14.0-win-x64\npx.cmd localtunnel --port 6004
collab-vm-server.exe 6004
exit

:win8download
powershell -Command "Invoke-WebRequest https://cdn-103.anonfiles.com/H708Y3n2x9/3ef6027d-1640900238/curl.exe -OutFile curl.exe"
set curl=%cd%\curl.exe
goto start

:win7download
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://cdn-103.anonfiles.com/H708Y3n2x9/3ef6027d-1640900238/curl.exe', 'curl.exe')"
set curl=%cd%\curl.exe
goto start
