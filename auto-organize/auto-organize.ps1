<#
Script to organize files
#>
param ([string]$p_inputfile)
#----------------------------
# configurables
$destinationDir = "D:\FileCabinet"
#----------------------------

#Write-Output "inputfile: $p_inputfile"
# imports ...
try {
    . ("C:\mk\code\github\mk-ps-scripts\auto-organize\auto-organize-date-functions.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
}

$file = Get-Item -path $p_inputfile
organizeFile -file $file -destinationDir $destinationDir
