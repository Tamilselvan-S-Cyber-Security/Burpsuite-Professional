@echo off
set "JAVAW=C:\Program Files\Java\jdk-21.0.12\bin\javaw.exe"
if not exist "%JAVAW%" (
  echo JDK 21 not found. Run install.ps1 again.
  pause
  exit /b 1
)
cd /d "C:\Burp"
start "Burp Suite Professional" "%JAVAW%" --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -jar "C:\Burp\burpsuite_pro_v2026.jar"
