Write-Host "Loading Date Functions..."



function isFileNameFormatted($fileName) {
    try {
    
        $pattern = "(?<text>.*)(?<date>\d{4}-\d{2}-\d{2})(?<text2>.*)"
        
        if($fileName -match $pattern) {
            #Write-Host "pattern matched"
            return $true
        } else {
            return $false
        }

    } catch {
        #Write-Host $_.Exception.Message
        # fail silently
    }
}

function getFormattedDateFromFileName($fileName) {
    
    Write-Host "getFormattedDateFromFileName($fileName)"
    
    $return = @()

    $pattern8 = "(?<text>.*)(?<date>\d{8})(?<text2>.*)"
    $pattern6 = "(?<text>.*)(?<date>\d{6})(?<text2>.*)" 

    if($fileName -match $pattern8) {
        #Write-Host "pattern8 matched"
        $oldDate = $matches.date
        $newDate = ([DateTime]::ParseExact($oldDate,"yyyyMMdd",$null)).ToString('yyyy-MM-dd')
    }
    
    
    elseif($fileName -match $pattern6) {
        #Write-Host "pattern6 matched"
        $oldDate = $matches.date 
        $newDate = ([DateTime]::ParseExact($oldDate,"MMddyy",$null)).ToString('yyyy-MM-dd')
        #Write-Host "newdate: $newdate"
        #Write-Host "olddate: $olddate"
    }
    else {
        #Write-Host "No matches for $fileName"
    }   
    
    if($newdate) {$return += $newdate}
    if($oldDate) {$return += $oldDate}

    return ,$return

}

function renameFileWithDate($file, $fileDate) 
{
        
    Write-Host "renameFileWithDate(file=$file, fileDate=$fileDate)"
    
    $oldName = $file.Name
    #Write-Host "oldname: $oldName"
    #Write-Host "date to string: $($fileDate.ToString("yyyy-MM-dd"))"

    $newName = $fileDate.ToString("yyyy-MM-dd") + " " + $oldName.Replace($fileDate.ToString("yyyy-MM-dd"),' ').Replace($fileDate.ToString("MMddyy"),' ').Replace('  ',' ').Replace(' .','.').Trim()
                    #+ $oldName.Replace($fileDate.ToString("MMddyy"),'').Replace('  ',' ').Replace(' .','.').Trim()
    
    Rename-Item -Path $file.FullName -newname $newName
    
    Write-Host "Renamed:  $($file.Name) -- $($newName)"
    
    $thisdir = Split-Path -Path $file -Parent
    #Write-Host "thisdir: $thisdir"
    $renamedPath = "$thisdir\$newName"

    if([System.IO.File]::Exists($renamedPath)){
        # file with path $path doesn't exist
        $renamedFile = Get-Item -Path $renamedPath
    } else {
        Write-Host "Renamed File: $($renamedPath) from original file:$($file.FullName) does not exist!"
        Write-Host "Exiting to prevent further errors..."
    }

    
    Write-Host $renamedFile
    return $renamedFile

}
function getDateFromFile($file) 
{
    $fileDate = Get-Date
    $primaryDatePattern = [Regex]::new('\b\d\d\d\d-\d\d-\d\d\b')
    $secondaryDatePattern = [Regex]::new('\b\d\d\d\d\d\d\b')
    Write-Host "$file  -------"
    $primaryMatches = $primaryDatePattern.Matches($file)
    $secondaryMatches = $secondaryDatePattern.Matches($file)
    #Write-Host $matches
    $primaryMatchIsValidDate = [DateTime]::TryParseExact($primaryMatches[0],"yyyy-MM-dd",[System.Globalization.CultureInfo]::InvariantCulture,
                                    [System.Globalization.DateTimeStyles]::None,
                                    [ref]$fileDate)

    $secondaryMatchIsValidDate = [DateTime]::TryParseExact($secondaryMatches[0],"MMddyy",[System.Globalization.CultureInfo]::InvariantCulture,
                                    [System.Globalization.DateTimeStyles]::None,
                                    [ref]$fileDate)

    #Write-Output "primary match $($primaryMatches[0])"
    #Write-Output "$primaryMatchIsValidDate"
    #Write-Output "secondary match $($secondaryMatches[0])"
    #Write-Output "$secondaryMatchIsValidDate"

    if($primaryMatches.Count -eq 1 -and $primaryMatchIsValidDate) {
        $fileDate = [datetime]::parseexact($primaryMatches[0],"yyyy-MM-dd",$null)
    } elseif($secondaryMatches.Count -eq 1 -and $secondaryMatchIsValidDate) {
        $fileDate = [datetime]::parseexact($secondaryMatches[0],"MMddyy",$null)
    } else {
        $fileDate = $file.LastWriteTime
        
    }
    
    #$return[0] = $fileDate.ToString('yyyy-MM-dd')
    #$return[1] = $primaryMatches[0].ToString('yyyy-MM-dd')
    #$return[2] = $secondaryMatches[0].ToString('MMddyy')  

 return $fileDate
}

function organizeFile($file, $destinationDir) {
    $fileDate = getDateFromFile $file

    #Write-Host $fileDate

    $dir = $destinationDir + "\" + $fileDate.ToString('yyyy') + "\" + $fileDate.ToString('MM-MMM')
    if (!(Test-Path $dir))
    {
	    New-Item $dir -type directory | Out-Null
    }

    # if filename doesn't begin with the date yyyy-MM-dd then add it here
    # might be redundant but who cares
    if(-Not($file.Name.StartsWith($fileDate.ToString("yyyy-MM-dd")))) {
        #Write-Host "$($file.Name) doesnt start with date $($fileDate.ToString("yyyy-MM-dd"))"
        $file = renameFileWithDate -file $file -fileDate $fileDate   
    } 
    else
    {
        # do nothing
        #Write-Host "FileName[ $($file.FullName) ] doesn't need renaming"
        
    }

    Write-Output "Moving $($file.fullname) to $dir "
    Move-Item $file.fullname $dir -Force

}
#function RecurseFiles($path = $pwd, [string[]]$exclude)
#{
##Write-Host "path: $path"
#    try {
#
#
#        foreach ($item in Get-ChildItem $path)
#        {
#
#            #Write-Host "item: $item"
#
#            if (Test-Path $item.FullName -PathType Container)
#            {
#                RecurseFiles $item.FullName $exclude
#            } 
#            else 
#            {
#            
#                #Write-Host $item.FullName
#            
#                if(-Not(isFileNameFormatted($item.Name))) {
#
#                    $dates = getFormattedDateFromFileName($item.Name)
#                    #Write-Host $dates
#                    #Write-Host $dates.Count
#                    if($dates.count -eq 2) {
#                        renameFileWithFormattedDate $item $dates[0] $dates[1]
#                    } 
#                    else
#                    {
#                        #Write-Host "No Date Found in FileName[ $($item.FullName) ]"
#                    }
#                }
#        
#           }
#        }  
#
#    } catch {
#        
#        "Error: file=[" + $item.FullName + "] exception=[" +  $_.Exception.Message + "]"| Out-File $LogFile -Append
#        # fail silently
#    }
#}

function TestGetDateFromFile() {
Remove-Item -Path "C:\Temp\2019-01-01 test.txt" | Out-Null
New-Item -Path "C:\Temp\test 010119.txt" | Out-Null
$file = Get-Item -Path "C:\Temp\test 010119.txt"
Write-Output $file
$dateFromFile = getDateFromFile -file $file
Write-Output $dateFromFile
$newFile = renameFileWithDate -file $file -fileDate $dateFromFile

if(Test-Path $newFile.FullName -PathType leaf) {
    Write-Host "renamed file $($newFile.FullName) exists"
} else {
    Write-Host "renamed file $($newFile.FullName) DOES NOT EXIST"
}
}