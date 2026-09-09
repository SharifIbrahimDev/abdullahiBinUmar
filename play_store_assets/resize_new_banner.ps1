Add-Type -AssemblyName System.Drawing

$outDir = $PSScriptRoot
$srcBanner = "C:\Users\USER\.gemini\antigravity-ide\brain\e27641ab-6ec8-4ceb-96e5-775b6b42ce27\feature_graphic_complete_1788963306634.jpg"
$outBannerPath = Join-Path $outDir "feature_graphic_1024x500.png"

if (Test-Path $srcBanner) {
    $img = [System.Drawing.Image]::FromFile($srcBanner)
    $bmp = New-Object System.Drawing.Bitmap 1024, 500
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.DrawImage($img, 0, 0, 1024, 500)
    
    if (Test-Path $outBannerPath) { Remove-Item -Force $outBannerPath }
    $bmp.Save($outBannerPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $g.Dispose()
    $bmp.Dispose()
    $img.Dispose()
    Write-Host "Created $outBannerPath (1024x500) with complete details & portrait!"
}
