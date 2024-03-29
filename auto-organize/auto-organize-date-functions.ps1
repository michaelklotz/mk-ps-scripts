﻿Write-Debug "Loading Date Functions..."



function isFileNameFormatted($itemName) {
    try {
    
        $pattern = "(?<text>.*)(?<date>\d{4}-\d{2}-\d{2})(?<text2>.*)"
        
        if($itemName -match $pattern) {
            Write-Debug "pattern matched"
            return $true
        } else {
            return $false
        }

    } catch {
        Write-Debug $_.Exception.Message
        # fail silently
    }
}

function getFormattedDateFromFileName($itemName) {
    
    Write-Debug "getFormattedDateFromFileName($itemName)"
    
    $return = @()

    $pattern8 = "(?<text>.*)(?<date>\d{8})(?<text2>.*)"
    $pattern6 = "(?<text>.*)(?<date>\d{6})(?<text2>.*)" 

    if($itemName -match $pattern8) {
        Write-Debug "pattern8 matched"
        $oldDate = $matches.date
        $newDate = ([DateTime]::ParseExact($oldDate,"yyyyMMdd",$null)).ToString('yyyy-MM-dd')
    }
    
    
    elseif($itemName -match $pattern6) {
        Write-Debug "pattern6 matched"
        $oldDate = $matches.date 
        $newDate = ([DateTime]::ParseExact($oldDate,"MMddyy",$null)).ToString('yyyy-MM-dd')
        Write-Debug "newdate: $newdate"
        Write-Debug "olddate: $olddate"
    }
    else {
        Write-Debug "No matches for $itemName"
    }   
    
    if($newdate) {$return += $newdate}
    if($oldDate) {$return += $oldDate}

    return ,$return

}

function renameItemWithDate($item, $itemDate) 
{
        
    Write-Debug "renameItemWithDate(file=$item, fileDate=$itemDate)"
    
    $oldName = $item.Name
    Write-Debug "oldname: $oldName"
    Write-Debug "date to string: $($itemDate.ToString("yyyy-MM-dd"))"

    $newName = $itemDate.ToString("yyyy-MM-dd") + " " + $oldName.Replace($itemDate.ToString("yyyy-MM-dd"),' ').Replace($itemDate.ToString("MMddyy"),' ').Replace('  ',' ').Replace('  ',' ').Replace(' .','.').Trim()
                    #+ $oldName.Replace($itemDate.ToString("MMddyy"),'').Replace('  ',' ').Replace(' .','.').Trim()
    
    Rename-Item -Path $item.FullName -newname $newName
    
    Write-Host "Renamed:  $($item.Name) --> $($newName)"
    
    $thisdir = Split-Path -Path $item -Parent
    Write-Debug "thisdir: $thisdir"
    $renamedPath = "$thisdir\$newName"

    Write-Debug "Renamed Path: $renamedPath"
    if(Test-Path -Path $renamedPath){
        # file with path $path doesn't exist
        $renamedFile = Get-Item -Path $renamedPath
    } else {
        Write-Debug "Renamed File: $($renamedPath) from original file:$($item.FullName) does not exist!"
        Write-Debug "Exiting to prevent further errors..."
    }

    
    Write-Debug $renamedFile
    return (Get-Item $renamedFile)

}
function getDateFromItem($item) 
{
    $itemDate = Get-Date
    $primaryDatePattern = [Regex]::new('\b\d\d\d\d-\d\d-\d\d\b')
    $secondaryDatePattern = [Regex]::new('\b\d\d\d\d\d\d\b')
    Write-Debug "$item  -------"
    $primaryMatches = $primaryDatePattern.Matches($item)
    $secondaryMatches = $secondaryDatePattern.Matches($item)
    Write-Host "$matches"
    $primaryMatchIsValidDate = [DateTime]::TryParseExact($primaryMatches[0],"yyyy-MM-dd",[System.Globalization.CultureInfo]::InvariantCulture,
                                    [System.Globalization.DateTimeStyles]::None,
                                    [ref]$itemDate)

    $secondaryMatchIsValidDate = [DateTime]::TryParseExact($secondaryMatches[0],"MMddyy",[System.Globalization.CultureInfo]::InvariantCulture,
                                    [System.Globalization.DateTimeStyles]::None,
                                    [ref]$itemDate)

    Write-Debug "primary match $($primaryMatches[0])"
    Write-Debug "$primaryMatchIsValidDate"
    Write-Debug "secondary match $($secondaryMatches[0])"
    Write-Debug "$secondaryMatchIsValidDate"

    if($primaryMatches.Count -eq 1 -and $primaryMatchIsValidDate) {
        $itemDate = [datetime]::parseexact($primaryMatches[0],"yyyy-MM-dd",$null)
    } elseif($secondaryMatches.Count -eq 1 -and $secondaryMatchIsValidDate) {
        $itemDate = [datetime]::parseexact($secondaryMatches[0],"MMddyy",$null)
    } else {
        $itemDate = $item.LastWriteTime
        
    }
    
    #$return[0] = $itemDate.ToString('yyyy-MM-dd')
    #$return[1] = $primaryMatches[0].ToString('yyyy-MM-dd')
    #$return[2] = $secondaryMatches[0].ToString('MMddyy')  

    return $itemDate
}

function organizeFile($itemPath, $destinationDir) {
    Write-Debug "organizeFile(itemPath=$itemPath, destinationDir=$destinationDir)"

    $item = Get-Item $itemPath
    Write-Debug "item name: $($item.Name)"
    $itemDate = getDateFromItem -item $item

    Write-Debug $itemDate

    $dir = $destinationDir + "\" + $itemDate.ToString('yyyy') + "\" + $itemDate.ToString('MM-MMM')
    Write-Debug $destinationDir

    Write-Debug $dir
    if (!(Test-Path $dir))
    {
	    New-Item $dir -type directory | Out-Null
    }

    
    # if filename doesn't begin with the date yyyy-MM-dd then add it here
    # might be redundant but who cares
    if(-Not($item.Name.StartsWith($itemDate.ToString("yyyy-MM-dd")))) {
        Write-Debug "$($item.Name) doesnt start with date $($itemDate.ToString("yyyy-MM-dd"))"
        $item = renameItemWithDate -item $item -itemDate $itemDate   
    } 
    else
    {
        # do nothing
        Write-Host "FileName[ $($item.FullName) ] doesn't need renaming"
        
    }

    Write-Host "Moving $($item.fullname) `n  to $dir "
    Move-Item "$($item.fullname)" "$dir" -Force

}
#function RecurseFiles($path = $pwd, [string[]]$exclude)
#{
#Write-Debug "path: $path"
#    try {
#
#
#        foreach ($item in Get-ChildItem $path)
#        {
#
#            Write-Debug "item: $item"
#
#            if (Test-Path $item.FullName -PathType Container)
#            {
#                RecurseFiles $item.FullName $exclude
#            } 
#            else 
#            {
#            
#                Write-Debug $item.FullName
#            
#                if(-Not(isFileNameFormatted($item.Name))) {
#
#                    $dates = getFormattedDateFromFileName($item.Name)
#                    Write-Debug $dates
#                    Write-Debug $dates.Count
#                    if($dates.count -eq 2) {
#                        renameFileWithFormattedDate $item $dates[0] $dates[1]
#                    } 
#                    else
#                    {
#                        Write-Debug "No Date Found in FileName[ $($item.FullName) ]"
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

