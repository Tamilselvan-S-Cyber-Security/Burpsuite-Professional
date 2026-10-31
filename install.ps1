# Burp Suite Pro — Windows setup (JDK 21 + launcher). Licensed/trial activation in Burp UI.
# Run as Admin optional. In PowerShell: Set-ExecutionPolicy -Scope Process Bypass; .\install.ps1

$ProgressPreference = 'SilentlyContinue'
$BurpDir = if ($PSScriptRoot) { $PSScriptRoot } else { "C:\Burp" }
Set-Location $BurpDir

Write-Host "Configuring JDK 21 jar runner..."
& "$BurpDir\Install-Jar-Runner.ps1"

$JdkRoot = $env:JAVA_HOME
$JavaExe = Join-Path $JdkRoot "bin\java.exe"
$JavawExe = Join-Path $JdkRoot "bin\javaw.exe"

Write-Host "`nDownloading Burp Suite Professional JAR (latest)..."
$version = "2026"
$jarName = "burpsuite_pro_v$version.jar"
try {
    Invoke-WebRequest -Uri "https://portswigger.net/burp/releases/download?product=pro&type=Jar" `
        -OutFile (Join-Path $BurpDir $jarName)
} catch {
    Write-Warning "Download failed: $_"
    $existing = Get-ChildItem "$BurpDir\burpsuite_pro_v*.jar" -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending | Select-Object -First 1
    if (-not $existing) { throw "No Burp JAR found in $BurpDir" }
    $jarName = $existing.Name
    Write-Host "Using existing JAR: $jarName"
}

$jarPath = Join-Path $BurpDir $jarName
$opens = @(
    '--add-opens=java.desktop/javax.swing=ALL-UNNAMED'
    '--add-opens=java.base/java.lang=ALL-UNNAMED'
    '--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED'
    '--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED'
) -join ' '

$bat = @"
@echo off
set "JAVAW=$JavawExe"
if not exist "%JAVAW%" (
  echo JDK 21 not found. Run install.ps1 again.
  pause
  exit /b 1
)
cd /d "$BurpDir"
start "Burp Suite Professional" "%JAVAW%" $opens -jar "$jarPath"
"@

Set-Content -Path (Join-Path $BurpDir "Burp.bat") -Value $bat -Encoding ASCII
Write-Host "Burp.bat created (uses JDK 21, keeps GUI open)."

$vbs = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run Chr(34) & "$BurpDir\Burp.bat" & Chr(34), 1, False
Set WshShell = Nothing
"@
Set-Content -Path (Join-Path $BurpDir "Burp-Suite-Pro.vbs") -Value $vbs -Encoding ASCII
Write-Host "Burp-Suite-Pro.vbs created."

Write-Host "`nStarting Burp Suite Professional..."
Start-Process -FilePath $JavawExe -ArgumentList ($opens.Split(' ') + @('-jar', $jarPath))
Write-Host "Burp should open in a few seconds. Activate license or trial in the app if prompted."
Write-Host "Shortcut: double-click Burp.bat or Burp-Suite-Pro.vbs"
