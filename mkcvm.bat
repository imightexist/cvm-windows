@echo off
title Starting script
md cvm
cd cvm
title Downloading Server
md server
cd server
powershell -Command "Invoke-WebRequest https://github-releases.githubusercontent.com/77417867/f52c9180-8e87-11eb-916e-32487d575ff1?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20211130%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20211130T040513Z&X-Amz-Expires=300&X-Amz-Signature=a9b8fab0c5200b139b7040c4142c0c28b6f3b270b4e9407e6803b896bf8b731d&X-Amz-SignedHeaders=host&actor_id=94249457&key_id=0&repo_id=77417867&response-content-disposition=attachment%3B%20filename%3Dcollab-vm-server-windows-amd64.zip&response-content-type=application%2Foctet-stream -OutFile server.zip"
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
7z x server.zip -y
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
npm install --global npm
npm install --global gulp-cli
cd..
cd webapp\collab-vm-web-app-master
"%node%\npm.cmd" install
"%node%\gulp.cmd"
title Copying files
cd build
copy *.* ..\..\..\server\http\*.* /Y
cd ..\..\..
title Done.
echo Script has finished, run "%cd%\server\collab-vm-server.exe 6004" to start server
set /p runserver=Do you want to start the server? (Y/N) 
if %runserver% == Y "%cd%\server\collab-vm-server.exe 6004"
if %runserver% == y "%cd%\server\collab-vm-server.exe 6004"
if %runserver% == N exit
if %runserver% == n exit
