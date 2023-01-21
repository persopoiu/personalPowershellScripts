$VerbosePreference = "SilentlyContinue"

$CurrentPrincipal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
$IsAdmin = $CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

If (!$IsAdmin) {
    # Request administrator permissions
    $url = "https://raw.githubusercontent.com/persopoiu/personalPowershellScripts/main/autoKRNL.ps1"
    $file = "$env:temp\autoKRNL.ps1"
    Invoke-WebRequest -Uri $url -OutFile $file

    Start-Process powershell -Verb runAs -File $file
    Exit
}


Set-MpPreference -DisableRealtimeMonitoring $true

Write-Host "Disabled Windows Antivirus"
$directory = Read-Host -Prompt 'Input the directory you would want it to download in: '

if (Test-Path -Path $directory) {
   if ($directory -notmatch "C:\\Windows\\(System32|System)") {
      Get-ChildItem -Path C:\Temp -Include *.* -File -Recurse | foreach { $_.Delete()}
   } else{
      Write-Host "I can't install the files in a important system window... sorry :/"
      pause
      Exit
   }
} else {
   Write-Host "Thats not a valid path?"
   pause
   Exit
}

Get-ChildItem -Path C:\Temp -Include *.* -File -Recurse | foreach { $_.Delete()}

$WebResponse = Invoke-WebRequest "https://wearedevs.net/d/Krnl"

$match = $response.Content | Select-String -Pattern "window.open('https://cdnwrd2.com/r/" -Context 0,0
if ($match) {
    $cleanedURL = $match.Line -replace '"', "" -replace "'", ""
    Invoke-WebRequest -Uri $cleanedURL -OutFile $directory
} else {
    Write-Host "Error while downloading krnl"
    pause
    Exit
}



Write-Host "KRNL should be installed"

pause
$VerbosePreference = "Continue"
