Add-Type -AssemblyName System.Drawing

$rootDir = Split-Path -Parent $PSScriptRoot
$outDir = $PSScriptRoot

# 1. 512x512 App Icon
$iconSrcPath = Join-Path $rootDir "assets\images\bin_umar.jpg"
if (Test-Path $iconSrcPath) {
    $src = [System.Drawing.Image]::FromFile($iconSrcPath)
    $bmp = New-Object System.Drawing.Bitmap 512, 512
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($src, 0, 0, 512, 512)
    $outPath = Join-Path $outDir "app_icon_512.png"
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    $src.Dispose()
    Write-Host "Created $outPath"
}

# 2. 1024x500 Feature Graphic from latest artifact
$genBanner = "C:\Users\USER\.gemini\antigravity-ide\brain\e27641ab-6ec8-4ceb-96e5-775b6b42ce27\feature_graphic_books_1788962375603.jpg"
if (Test-Path $genBanner) {
    $srcBanner = [System.Drawing.Image]::FromFile($genBanner)
    $bmpBanner = New-Object System.Drawing.Bitmap 1024, 500
    $gBanner = [System.Drawing.Graphics]::FromImage($bmpBanner)
    $gBanner.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gBanner.DrawImage($srcBanner, 0, 0, 1024, 500)
    $outBannerPath = Join-Path $outDir "feature_graphic_1024x500.png"
    $bmpBanner.Save($outBannerPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $gBanner.Dispose()
    $bmpBanner.Dispose()
    $srcBanner.Dispose()
    Write-Host "Created $outBannerPath"
}
