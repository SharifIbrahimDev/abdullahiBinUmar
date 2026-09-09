Add-Type -AssemblyName System.Drawing

$rootDir = Split-Path -Parent $PSScriptRoot
$outDir = $PSScriptRoot

$baseBanner = "C:\Users\USER\.gemini\antigravity-ide\brain\e27641ab-6ec8-4ceb-96e5-775b6b42ce27\feature_graphic_complete_1788963306634.jpg"
$avatarSrcPath = Join-Path $rootDir "assets\images\abdullah.jpg"
$outBannerPath = Join-Path $outDir "feature_graphic_1024x500.png"

if ((Test-Path $baseBanner) -and (Test-Path $avatarSrcPath)) {
    # 1. Base banner 1024x500
    $srcBanner = [System.Drawing.Image]::FromFile($baseBanner)
    $finalBmp = New-Object System.Drawing.Bitmap 1024, 500
    $g = [System.Drawing.Graphics]::FromImage($finalBmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.DrawImage($srcBanner, 0, 0, 1024, 500)
    $srcBanner.Dispose()

    # 2. Actual photo of Sheikh Abdullahi
    $avatarImg = [System.Drawing.Image]::FromFile($avatarSrcPath)

    # Medallion inner circle coordinates on 1024x500 image
    # Center is approx X: 735, Y: 250. Diameter is approx 270px
    $d = 270
    $cx = 736 - ($d / 2)
    $cy = 252 - ($d / 2)

    # Create circular cropped avatar
    $avatarBmp = New-Object System.Drawing.Bitmap $d, $d
    $gAvatar = [System.Drawing.Graphics]::FromImage($avatarBmp)
    $gAvatar.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $gAvatar.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddEllipse(0, 0, $d, $d)
    $gAvatar.SetClip($path)
    # Draw actual photo centered & scaled nicely
    $gAvatar.DrawImage($avatarImg, 0, 0, $d, $d)
    $gAvatar.ResetClip()

    # Draw the actual photo inside the medallion
    $g.DrawImage($avatarBmp, [int]$cx, [int]$cy)

    # Draw subtle inner gold rim to seamlessly blend edges
    $goldInnerPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(200, 218, 165, 32), 3)
    $g.DrawEllipse($goldInnerPen, [int]$cx, [int]$cy, $d, $d)

    # Cleanup
    $goldInnerPen.Dispose()
    $path.Dispose()
    $gAvatar.Dispose()
    $avatarBmp.Dispose()
    $avatarImg.Dispose()
    $g.Dispose()

    if (Test-Path $outBannerPath) { Remove-Item -Force $outBannerPath }
    $finalBmp.Save($outBannerPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $finalBmp.Dispose()

    Write-Host "Successfully integrated actual abdullah.jpg into $outBannerPath"
}
