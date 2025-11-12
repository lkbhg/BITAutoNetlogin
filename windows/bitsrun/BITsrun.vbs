Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "cmd /c D:\bitsrun\BITsrun.bat", 0, True
Set WshShell = Nothing