@echo off

for %%a in (%*) do (
	echo Organizing file:[%%a]
	powershell -noprofile -command "C:\mk\code\github\mk-ps-scripts\journal-cleanup\journal-cleanup.ps1 -p_inputfile \"%%a\""
	
)
pause