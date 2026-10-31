Set WshShell = CreateObject("WScript.Shell")
WshShell.Run Chr(34) & "C:\Burp\Burp.bat" & Chr(34), 1, False
Set WshShell = Nothing
