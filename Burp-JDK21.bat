@echo off
set "JAVAW=C:\Program Files\Java\jdk-21.0.12\bin\javaw.exe"
if not exist "%JAVAW%" set "JAVAW=%JAVA_HOME%\bin\javaw.exe"
if not exist "%JAVAW%" (
  echo JDK 21 not found. Run install.ps1 or Install-Jar-Runner.ps1
  pause
  exit /b 1
)
cd /d "C:\Burp"
set "JAR=burpsuite_pro_v2026.jar"
if not exist "%JAR%" set "JAR=burpsuite_pro_v2025.jar"
start "Burp Suite Professional" "%JAVAW%" ^
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED ^
  --add-opens=java.base/java.lang=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED ^
  -jar "C:\Burp\%JAR%"
