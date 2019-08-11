@echo off

for %%a in (%*) do (
	echo Organizing file:[%%a]
	powershell -noprofile -command "C:\mk\code\github\mk-ps-scripts\auto-organize\auto-organize.ps1 -p_inputfile \"%%a\""
	
)
pause