<#
Script to cleanup journal files and archive them
#>
param ([string]$p_inputfile)
#----------------------------
# configurables
$destinationDir = "C:\Users\Klotz\OneDrive\journal-sync"
#----------------------------

#Write-Output "inputfile: $p_inputfile"
# imports ...
try {
    . ("C:\mk\code\github\mk-ps-scripts\auto-organize\auto-organize-date-functions.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
}

$content = Get-Content $p_inputfile -Encoding UTF8 -Raw
$regexPattern = '.*(?:[\r\n]+\.\.\..*)*[\r\n]+'
$cleanContent = ""

$matches = $content | Select-String -Pattern $regexPattern -AllMatches | %{$_.Matches} | %{$_.Value}

$matchesSorted = $matches | Sort-Object
For ($i=0; $i -le $matchesSorted.Count; $i++) {
 if($matchesSorted[$i] -ne $null) {
     if($matchesSorted[$i].substring(0,3) -ne $matchesSorted[$i-1].substring(0,3)) {
       $cleanContent += "`n------"
     }
    $cleanContent += "`n" + $matchesSorted[$i].Trim()
  }
}
$cleanContent += "`n------"

$cleanContent | Out-File "C:\mk\code\github\mk-ps-scripts\journal-cleanup\new.txt"
#$file = Get-Item -path $p_inputfile
#organizeFile -file $file -destinationDir $destinationDir
#organizeFile -itemPath $p_inputfile -destinationDir $destinationDir
