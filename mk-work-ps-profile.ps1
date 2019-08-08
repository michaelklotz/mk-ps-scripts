Write-Host "Loading Mike's Work Profile"

$dirs.add("downloads","C:\Users\M136815\Downloads");
$dirs.add("onedrive", "C:\Users\M136815\OneDrive");
$dirs.add("desktop", "C:\Users\M136815\Desktop");
$dirs.add("di", "\\mfad.mfroot.org\RCHDept\EDW\ADW\DataIntegration");
$dirs.add("adwtestprj", "C:\mk\code\git-tfs\ADWTEST_PRJ");
$dirs.add("gittfs", "C:\mk\code\git-tfs");
$dirs.add("adwdbatest", "C:\mk\code\git-tfs\ADWDBATEST");
function backupAttributes ($filter="") 
{
	\\mfad.mfroot.org\RCHDept\EDW\ADW\Common\CheckBackupFilesAttributes.ps1 -filter $filter
}
