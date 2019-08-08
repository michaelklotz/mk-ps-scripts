$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

try {
    . ("C:\mk\code\github\mk-ps-scripts\auto-organize\auto-organize-date-functions.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
}



Remove-Item -Recurse -Force "$scriptPath\file-organizer-tests"

New-Item -ItemType Directory -Force -Path "$scriptPath\file-organizer-tests"
New-Item -ItemType Directory -Force -Path "$scriptPath\file-organizer-tests\inbox"
New-Item -ItemType Directory -Force -Path "$scriptPath\file-organizer-tests\archive"


######## FOLDERS 
# Project B 080819 Folder
New-Item -ItemType Directory -Force -Path "$scriptPath\file-organizer-tests\inbox\Project B 080819" # valid date, folder
New-Item -Path "$scriptPath\file-organizer-tests\inbox\Project B 080819" -Name "project b file.txt" -ItemType "file" -Value "This is a text string."

# Project C 180819 Folder
New-Item -ItemType Directory -Force -Path "$scriptPath\file-organizer-tests\inbox\Project C 180819" # invalid date, folder
New-Item -Path "$scriptPath\file-organizer-tests\inbox\Project C 180819" -Name "project c file.txt" -ItemType "file" -Value "This is a text string."
(Get-Item "$scriptPath\file-organizer-tests\inbox\Project C 180819").CreationTime = New-object DateTime 2011,12,31
(Get-Item "$scriptPath\file-organizer-tests\inbox\Project C 180819").LastWriteTime = New-object DateTime 2011,12,31

# Project D Folder
# explicitly set the created, modified date
New-Item -ItemType Directory -Force -Path "$scriptPath\file-organizer-tests\inbox\Project D" # no date, folder
New-Item -Path "$scriptPath\file-organizer-tests\inbox\Project D" -Name "project d file.txt" -ItemType "file" -Value "This is a text string."
(Get-Item "$scriptPath\file-organizer-tests\inbox\Project D").CreationTime = New-object DateTime 2010,01,01
(Get-Item "$scriptPath\file-organizer-tests\inbox\Project D").LastWriteTime = New-object DateTime 2010,01,01


###### FILES

New-Item -Path "$scriptPath\file-organizer-tests\inbox" -Name "File E 10182015.txt" -ItemType "file" -Value "original name File E 10182015"
(Get-Item "$scriptPath\file-organizer-tests\inbox\File E 10182015.txt").CreationTime = New-object DateTime 2010,02,01
(Get-Item "$scriptPath\file-organizer-tests\inbox\File E 10182015.txt").LastWriteTime = New-object DateTime 2010,02,01

New-Item -Path "$scriptPath\file-organizer-tests\inbox" -Name "File F 101915.txt" -ItemType "file" -Value "original name File F 101915"
New-Item -Path "$scriptPath\file-organizer-tests\inbox" -Name " 062418 File G.txt" -ItemType "file" -Value "original name 062418 File G"
New-Item -Path "$scriptPath\file-organizer-tests\inbox" -Name " 131313 File H.txt" -ItemType "file" -Value "original name 131313 File H"
(Get-Item "$scriptPath\file-organizer-tests\inbox\ 131313 File H.txt").CreationTime = New-object DateTime 2012,03,01
(Get-Item "$scriptPath\file-organizer-tests\inbox\ 131313 File H.txt").LastWriteTime = New-object DateTime 2012,03,01

New-Item -Path "$scriptPath\file-organizer-tests\inbox" -Name "File 121313 I  .txt" -ItemType "file" -Value "original name File 121313 I  "
New-Item -Path "$scriptPath\file-organizer-tests\inbox" -Name "File J.txt" -ItemType "file" -Value "original name File J "
(Get-Item "$scriptPath\file-organizer-tests\inbox\File J.txt").CreationTime = New-object DateTime 2014,04,01
(Get-Item "$scriptPath\file-organizer-tests\inbox\File J.txt").LastWriteTime = New-object DateTime 2014,04,01

###### RUN THE TESTS
organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\Project B 080819" -destinationDir "$scriptPath\file-organizer-tests\archive"
organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\Project C 180819" -destinationDir "$scriptPath\file-organizer-tests\archive"
organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\Project D" -destinationDir "$scriptPath\file-organizer-tests\archive"

organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\File E 10182015.txt" -destinationDir "$scriptPath\file-organizer-tests\archive"
organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\File F 101915.txt" -destinationDir "$scriptPath\file-organizer-tests\archive"
organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\ 062418 File G.txt" -destinationDir "$scriptPath\file-organizer-tests\archive"
organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\ 131313 File H.txt" -destinationDir "$scriptPath\file-organizer-tests\archive"
organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\File 121313 I  .txt" -destinationDir "$scriptPath\file-organizer-tests\archive"
organizeFile -itemPath "$scriptPath\file-organizer-tests\inbox\File J.txt" -destinationDir "$scriptPath\file-organizer-tests\archive"

Write-Host "Test Results......"

# B
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2019\08-Aug\2019-08-08 Project B" -PathType Container) {
    Write-Host "Test Case B.Folder Success"
} else {
    Write-Host "Test Case B.Folder Failed"
}

if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2019\08-Aug\2019-08-08 Project B\project b file.txt" -PathType Leaf) {
    Write-Host "Test Case B.File Success"
} else {
    Write-Host "Test Case B.File Failed"
}

# C 
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2011\12-Dec\2011-12-31 Project C 180819" -PathType Container) {
    Write-Host "Test Case C.Folder Success"
} else {
    Write-Host "Test Case C.Folder Failed"
}

if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2011\12-Dec\2011-12-31 Project C 180819\project c file.txt" -PathType Leaf) {
    Write-Host "Test Case C.File Success"
} else {
    Write-Host "Test Case C.File Failed"
}

# D
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2010\01-Jan\2010-01-01 Project D" -PathType Container) {
    Write-Host "Test Case D.Folder Success"
} else {
    Write-Host "Test Case D.Folder Failed"
}

if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2010\01-Jan\2010-01-01 Project D\project d file.txt" -PathType Leaf) {
    Write-Host "Test Case D.File Success"
} else {
    Write-Host "Test Case D.File Failed"
}


# E
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2010\02-Feb\2010-02-01 File E 10182015.txt" -PathType Leaf) {
    Write-Host "Test Case E.File Success"
} else {
    Write-Host "Test Case E.File Failed"
}

# F
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2015\10-Oct\2015-10-19 File F.txt" -PathType Leaf) {
    Write-Host "Test Case F.File Success"
} else {
    Write-Host "Test Case F.File Failed"
}

# G
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2018\06-Jun\2018-06-24 File G.txt" -PathType Leaf) {
    Write-Host "Test Case G.File Success"
} else {
    Write-Host "Test Case G.File Failed"
}

# H
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2012\03-Mar\2012-03-01 131313 File H.txt" -PathType Leaf) {
    Write-Host "Test Case H.File Success"
} else {
    Write-Host "Test Case H.File Failed"
}

# H
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2013\12-Dec\2013-12-13 File I.txt" -PathType Leaf) {
    Write-Host "Test Case I.File Success"
} else {
    Write-Host "Test Case I.File Failed"
}

# J
if(Test-Path -Path "$scriptPath\file-organizer-tests\archive\2014\04-Apr\2014-04-01 File J.txt" -PathType Leaf) {
    Write-Host "Test Case J.File Success"
} else {
    Write-Host "Test Case J.File Failed"
}