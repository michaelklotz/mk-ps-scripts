$content = Get-Content "C:\Users\Klotz\OneDrive\journal\2019\2019-09-28-wed.txt" -Encoding UTF8 -Raw
$regexPattern = '.*(?:[\r\n]+\.\.\..*)*[\r\n]+'
#Write-Host $content
#$content | Select-String ".*(?:[\r\n]+\.\.\..*)*[\r\n]+" -AllMatches | % matches 
$matches = $content | Select-String -Pattern $regexPattern -AllMatches | %{$_.Matches} | %{$_.Value}
#Write-Host "matches" $matches
#foreach($match in $matches) {
#Write-Host $match
#}
$matchesSorted = $matches | Sort-Object
For ($i=0; $i -le $matchesSorted.Count; $i++) {
 #if($i -gt 0) {
 if($matchesSorted[$i].substring(0,2) -ne $matchesSorted[$i-1].substring(0,2) -or $i -eq 0) {
   Write-Host "---$($matchesSorted[$i].substring(0,2))---"
 }
 #}
 Write-Host $matchesSorted[$i]
}

#$content | Where {$_ -match ".*(?:[\r\n]+\.\.\..*)*[\r\n]+"} | Foreach {$Matches[0]}