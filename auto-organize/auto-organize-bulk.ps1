<#
bulk file organizer
#>
#----------------------------
# configurables
$destinationDir = "D:\FileCabinet"
#----------------------------
$dirsToOrganize = @(
    "D:\File Cabinet\House",
    "D:\File Cabinet\Incidents",
    "D:\File Cabinet\Medical",
    "D:\File Cabinet\Reference",
    "D:\File Cabinet\Travel"
)

try {
    . ("D:\Scripts\DateFunctions.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
}

foreach ($path in $dirsToOrganize) {

    $files = get-childitem $path 

    foreach ($file in $files) 
    {
        #$file = Get-Item -path $p_inputfile
        Write-Host "File: $($file.Name)"
        organizeFile -file $file -destinationDir $destinationDir
    }
}
Read-Host "Press Enter to Exit..."