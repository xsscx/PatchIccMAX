Get-ChildItem -Path "Testing/" -Recurse -Filter *.exe | ForEach-Object { Start-Process -FilePath $_.FullName -NoNewWindow -Wait }
