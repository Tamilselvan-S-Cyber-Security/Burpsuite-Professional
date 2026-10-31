# Installs JDK 21 if missing and adds it to your USER Path (jar runner).
# Run:  Set-ExecutionPolicy -Scope Process Bypass; .\Install-Jar-Runner.ps1

$ErrorActionPreference = "Stop"
$JdkRoot = "C:\Program Files\Java\jdk-21.0.12"
$JavaExe = Join-Path $JdkRoot "bin\java.exe"

function Test-Jdk21 {
    Test-Path $JavaExe
}

if (-not (Test-Jdk21)) {
    Write-Host "JDK 21 not found at $JdkRoot"
    Write-Host "Installing Oracle JDK 21 via winget..."
    winget install --id Oracle.JDK.21 -e --accept-source-agreements --accept-package-agreements
    $candidates = Get-ChildItem "C:\Program Files\Java\jdk-21*" -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending
    if ($candidates) {
        $JdkRoot = $candidates[0].FullName
        $JavaExe = Join-Path $JdkRoot "bin\java.exe"
    }
}

if (-not (Test-Path $JavaExe)) {
    Write-Error "JDK 21 still not found. Install from https://www.oracle.com/java/technologies/downloads/#java21"
}

$bin = Join-Path $JdkRoot "bin"
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$paths = $userPath -split ";" | Where-Object { $_ -and $_ -ne $bin }
$newPath = ($bin, ($paths -join ";")) -join ";"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")
[Environment]::SetEnvironmentVariable("JAVA_HOME", $JdkRoot, "User")

$env:Path = "$bin;" + [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + $newPath
$env:JAVA_HOME = $JdkRoot

Write-Host "`nJar runner ready."
Write-Host "  JAVA_HOME = $JdkRoot"
& $JavaExe -version
Write-Host @"

Run Burp:
  .\Burp-JDK21.bat

Run any JAR:
  .\Run-Jar.bat .\burpsuite_pro_v2026.jar

Open a NEW PowerShell window so Path changes apply.
"@
