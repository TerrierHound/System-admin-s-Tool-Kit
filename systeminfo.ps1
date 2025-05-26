# Masaüstü yolu doğrudan tanımlanıyor
$logPath = "C:\Users\pc\Desktop\system_info_log.txt"

"===== Sistem Bilgisi =====" | Out-File -FilePath $logPath -Encoding utf8
"Bilgisayar Adi: $env:COMPUTERNAME" | Out-File -Append -FilePath $logPath
"Kullanici Adi: $env:USERNAME" | Out-File -Append -FilePath $logPath

"----- CPU Bilgisi -----" | Out-File -Append -FilePath $logPath
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, MaxClockSpeed | Out-String | Out-File -Append -FilePath $logPath

"----- Ram Bilgisi -----" | Out-File -Append -FilePath $logPath
Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Capacity, Speed | Out-String | Out-File -Append -FilePath $logPath

"----- Disk Bilgisi -----" | Out-File -Append -FilePath $logPath
Get-PSDrive -PSProvider 'FileSystem' | Select-Object Name, Free, Used, @{Name="Total"; Expression={$_.Free + $_.Used}} | Out-String | Out-File -Append -FilePath $logPath

"----- Tarih & Saat -----" | Out-File -Append -FilePath $logPath
Get-Date | Out-File -Append -FilePath $logPath

Write-Host "✅ Sistem Bilgileri Başariyla Toplandi. Log Dosyasi: $logPath"
