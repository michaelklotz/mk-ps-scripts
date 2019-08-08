@echo off

for %%a in (%*) do (
	echo Organizing file:[%%a]
	powershell -command "D:\Scripts\FileOrganizer.ps1 -p_inputfile \"%%a\""
	
)
pause