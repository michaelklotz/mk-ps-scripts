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
    . ("D:\Scripts\DateFunctions.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
}

$file = Get-Item -path $p_inputfile
organizeFile -file $file -destinationDir $destinationDir
