Write-Host "Loading Mike's Common Profile"
$yr = Get-Date -Format yyyy
$mo = Get-Date -Format MM

# so nano can handle files with text created by powershell...
$PSDefaultParameterValues = @{ '*:Encoding' = 'utf8' }

# dependencies
# Install-Module pscx
#

set-alias ransack "C:\Program Files\Mythicsoft\Agent Ransack\AgentRansack.exe"
#set-alias edit "C:\Program Files (x86)\IDM Computer Solutions\UltraEdit\uedit32.exe"
#set-alias nano "C:\Program Files\Git\usr\bin\nano.exe"
#Set-Alias npp "C:\Program Files (x86)\Notepad++\notepad++.exe"
#set-alias ssms "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe"
set-alias ie "C:\Program Files\Internet Explorer\iexplore.exe"
#set-alias xy "C:\PortableApps\XYplorer\XYplorerFree.exe"
#set-alias code "C:\Program Files\Microsoft VS Code\Code.exe"
set-alias micro "C:\Program Files\micro-1.4.1\micro.exe"

# posh-git
Import-Module C:\mk\code\github\posh-git\src\posh-git.psd1
    
function tail ($path) 
{
	Get-Content -Path $path -Wait
}

function cal {
   $input = $Args[0]
	Get-Content "C:\mk\common-sync\calorie-lookup.csv" | Select-String -Pattern $input
}

function go-mk { cd "C:\mk" }
function go-archive { cd "C:\mk\archive" }
function go-temp { cd "C:\mk\temp" }
function go-downloads { cd "C:\Users\m136815\Downloads" }
function go-code { cd "C:\mk\code" }

# list of common directories
$dirs = @{
   temp = "C:\mk\temp";
   code = "C:\mk\code";
   gittfs = "C:\mk\code\git-tfs";
   adwtestprj = "C:\mk\code\git-tfs\ADWTEST_PRJ";
   download = "C:\Users\M136815\Downloads";
   onedrive = "C:\Users\M136815\OneDrive";
   desktop = "C:\Users\M136815\Desktop";
   di = "mfad.mfroot.org\RCHDept\EDW\ADW\DataIntegration";
   shortcuts = "C:\mk\folder-shortcuts"
}


# for task switcher
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class SFW {
     [DllImport("user32.dll")]
     [return: MarshalAs(UnmanagedType.Bool)]
     public static extern bool SetForegroundWindow(IntPtr hWnd);
  }
"@
# switch-task
function st($proc,$idx=99) { 
   $processesMatching =  Get-Process | Where-Object { $_.MainWindowTitle -like "*$proc*" -or $_.Name -like "*$proc*"}
   if($processesMatching.count -gt 1 -and $idx -eq 99) {
      $processesMatching | Format-Table @{Label="Index"; Expression={[array]::indexOf($processesMatching,$_)}},
      ProcessName,
      MainWindowTitle,
      MainWindowHandle
      #foreach($hh in $h) {
      #   "" + [array]::indexOf($h,$hh) + " " + $hh.ProcessName + " " + $hh.MainWindowTitle 
      #}
      $idx = Read-Host -Prompt 'Which Process Index?'   
   } else {
      if($idx -eq 99) { 
         $idx = 0
      }
   }
   if($processesMatching.count -lt $idx-1) {
      "No process matching $proc at idx:$idx exists"
      return
   }
   
   $process =  $processesMatching[$idx]
   [SFW]::SetForegroundWindow($process.MainWindowHandle)
}




#function create-task {
#param (
#    [Parameter(Mandatory=$true)]
#	[string] $name,
#	[string] $type="folder",
#	[string] $text,
#	[switch] $open
#  )
#     if($type -eq "folder") {
#        $t = New-Item -Path $taskDir -Name $name -ItemType "directory"
#        if(-not [string]::IsNullOrEmpty($text)){
#            New-Item -Path $t -Name "$($name).txt" -ItemType "file" -Value $text
#        }
#     } else {
#        $t = New-Item -Path $taskDir -Name "$($name).txt" -ItemType "file" -Value $text
#     }
#     
#     write-host $t
#     if($open) {
#        Invoke-Item $t
#     }
#}
#function create-task {
#param (
#	[string] $name,
#	[switch] $of,
#	[switch] $od
#  )
#	 
#	 # ask for task name if not provided
#	if([string]::IsNullOrEmpty($n)) {
#		$taskname = Read-Host "Task Name"
#	} else {
#		$taskname = $name
#	}
#	
#	$taskname = $taskname -replace " ", "_"
#    $taskfile = "$taskname.txt"
#	$taskfolder = "$taskFoldersDir\$taskname"
#	
#	if(Test-Path -Path "$taskListDir\$taskfile") {
#		Write-Output "Task file not created - already exists: $taskListDir\$taskfile"
#		return
#	}
#	$createdTaskFile = New-Item -Path $taskListDir -Name $taskfile -ItemType "file"
#	write-output "Created File: $($createdTaskFile.FullName)"
#	
#	# create the corresponding directory
#	$createdtaskdir = New-Item -ItemType Directory -Force -Path $taskfolder  #>$null 2>&1
#	write-output "Created Directory: $($createdtaskdir.FullName)"
#	
#	#$encodedlink = $createdtaskdir.FullName -replace " ", "%20"
#	#$encodedlink = "file://$encodedlink" 
#	Add-Content $createdTaskFile "TaskFolder: file://$($createdtaskdir.FullName)"
#	#Add-Content $createdTaskFile "Link: $link"
#	
#	# create shortcut to the task file in the task folder
#	$wshshell = New-Object -ComObject WScript.Shell
#	$lnk = $wshshell.CreateShortcut("$createdtaskdir\$taskname.lnk")
#	$lnk.TargetPath = $createdTaskFile.FullName
#	$lnk.Save() 
#  
#    if($of) {
#        nano $createdTaskFile
#    }
#	if($od) {
#        Invoke-Item $taskdirfullpath
#    }
#}







