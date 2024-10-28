 Get-ChildItem -Path "IccXML", "Tools/" -Recurse -Include *.exe | ForEach-Object { Write-Host "Checking: $($_.FullName)"; link /dump /dependents $_.FullName
 | Select-String -NotMatch ".data|.pdata|.reloc|.rsrc|.text|.INTR|.WEAK|.debug|.00cfg|.tls|.CRT|.bss|.chks64|.drectve|.rtc|.voltbl|.comment|.gfids|.eh_fram|.rsrc$|.stab" }
