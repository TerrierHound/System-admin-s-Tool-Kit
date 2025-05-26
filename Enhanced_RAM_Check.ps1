Add-Type -AssemblyName System.Windows.Forms

# Log dosyasının yolu (Desktop'a)
$logPath = "$env:USERPROFILE\Desktop\ram_monitor_log.txt"

# RAM kullanım eşiği
$threshold = 20

while ($true) {
    Clear-Host

    # Geri sayımı göster
    for ($i = 10; $i -ge 1; $i--) {
        Write-Host "Yeni kontrol $i saniye içinde yapilacak..." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        Clear-Host
    }

    # Sistem RAM bilgisi
    $os = Get-CimInstance Win32_OperatingSystem
    $totalKB = [float]$os.TotalVisibleMemorySize
    $freeKB = [float]$os.FreePhysicalMemory
    $usedKB = $totalKB - $freeKB
    $usagePercent = [math]::Round(($usedKB / $totalKB) * 100, 2)

    # Zaman etiketi
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Log mesajı
    $logMessage = "$timestamp - RAM Kullanimi: %$usagePercent"

    # RAM durumuna göre log ve bildirim
    if ($usagePercent -gt $threshold) {
        Write-Host "Uyari! RAM kullanimi yüksek: %$usagePercent" -ForegroundColor Red
        $logMessage += " - UYARI"

        # Bildirim balonu (Windows)
        [System.Windows.Forms.NotifyIcon]$notification = New-Object System.Windows.Forms.NotifyIcon
        $notification.Icon = [System.Drawing.SystemIcons]::Warning
        $notification.BalloonTipIcon = "Warning"
        $notification.BalloonTipTitle = "RAM Uyarisi"
        $notification.BalloonTipText = "RAM kullanimi %$usagePercent seviyesinde!"
        $notification.Visible = $true
        $notification.ShowBalloonTip(5000)
    }
    else {
        Write-Host "RAM kullanimi normal: %$usagePercent" -ForegroundColor Green
    }

    # Log'a yaz
    $logMessage | Out-File -Append -FilePath $logPath -Encoding utf8
}
