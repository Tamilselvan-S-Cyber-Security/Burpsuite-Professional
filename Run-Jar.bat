@echo off
setlocal
set "JAVA_EXE=C:\Program Files\Java\jdk-21.0.12\bin\java.exe"
set "JAVAW_EXE=C:\Program Files\Java\jdk-21.0.12\bin\javaw.exe"

if not exist "%JAVA_EXE%" (
  echo JDK 21 not found. Run Install-Jar-Runner.ps1 as Administrator, or install JDK 21.
  pause
  exit /b 1
)

if "%~1"=="" (
  echo Usage: Run-Jar.bat path\to\file.jar
  echo   Or drag a .jar file onto this script.
  pause
  exit /b 1
)

if /i not "%~x1"==".jar" (
  echo Not a .jar file: %~1
  pause
  exit /b 1
)

if /i "%~nx1"=="burpsuite_pro_v2026.jar" goto :burp
if /i "%~nx1"=="burpsuite_pro_v2025.jar" goto :burp

"%JAVA_EXE%" -jar "%~f1"
exit /b %ERRORLEVEL%

:burp
start "" "%JAVAW_EXE%" ^
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED ^
  --add-opens=java.base/java.lang=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED ^
  -jar "%~f1"
exit /b 0
