#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")

#w::
{
    if ProcessExist("chrome.exe")
    {
        WinActivate("ahk_exe chrome.exe")
        Send("^t")
    }
    else
    {
        Run("chrome.exe")
    }
}

#+w::Run("chrome.exe -incognito")
