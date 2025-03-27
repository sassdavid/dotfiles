vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
        ["+"] = "/c/Windows/System32/clip.exe",
        ["*"] = "/c/Windows/System32/clip.exe",
    },
    paste = {
        ["+"] = '/c/Program Files/PowerShell/7/pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).ToString().Replace("`r", ""))',
        ["*"] = '/c/Program Files/PowerShell/7/pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).ToString().Replace("`r", ""))',
    },
    cache_enabled = 0,
}
