Get-ChildItem -Path R:\TEMP -Filter "*.txt" | Rename-Item -NewName {$_.Name -replace '.txt','.MD'}
