#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")

#t::ToggleTerminal()

ToggleTerminal()
{
    WinClass := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"
    DetectHiddenWindows(true)

    if WinExist(WinClass)
    {
        DetectHiddenWindows(false)

        if !WinActive(WinClass)
        {
            ShowAndPositionTerminal(WinClass)
        }
        else
        {
            WinHide(WinClass)
            Send("!{Esc}")
        }
    }
    else
    {
        RunTerminalAsAdmin()
        Sleep(1500)
        ShowAndPositionTerminal(WinClass)
    }
}

ShowAndPositionTerminal(WinClass)
{
    try {
        WinShow(WinClass)
        WinActivate(WinClass)

        MonitorGetWorkArea(, &WorkAreaLeft, &WorkAreaTop, &WorkAreaRight, &WorkAreaBottom)
        TerminalWidth := A_ScreenWidth * 0.95
        TerminalHeight := A_ScreenHeight * 0.9

        WinMove((A_ScreenWidth - TerminalWidth) / 2, (A_ScreenHeight - TerminalHeight) / 2,
                TerminalWidth, TerminalHeight, WinClass)
    } catch {
        MsgBox("Can't resize Terminal window.`nMake sure the script is running as administrator.")
    }
}

RunTerminalAsAdmin()
{
    localappdata := EnvGet("LOCALAPPDATA")
    userProfile := EnvGet("USERPROFILE")
    TerminalPath := localappdata . "\Microsoft\WindowsApps\wt.exe"
    params := '-d "' . userProfile . '"'

    shell := ComObject("Shell.Application")
    shell.ShellExecute(TerminalPath, params, userProfile, "runas")
}
