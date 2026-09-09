Add-Type -AssemblyName System.Drawing

$rootDir = Split-Path -Parent $PSScriptRoot
$outDir = $PSScriptRoot

$baseBanner = "C:\Users\USER\.gemini\antigravity-ide\brain\e27641ab-6ec8-4ceb-96e5-775b6b42ce27\feature_graphic_books_1788962375603.jpg"
$avatarSrcPath = Join-Path $rootDir "assets\images\abdullah.jpg"
$outBannerPath = Join-Path $outDir "feature_graphic_1024x500.png"

if ((Test-Path $baseBanner) -and (Test-Path $avatarSrcPath)) {
    $srcBanner = [System.Drawing.Image]::FromFile($baseBanner)
    $finalBmp = New-Object System.Drawing.Bitmap 1024, 500
    $g = [System.Drawing.Graphics]::FromImage($finalBmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    
    # 1. Draw base banner resized to 1024x500
    $g.DrawImage($srcBanner, 0, 0, 1024, 500)
    $srcBanner.Dispose()

    # 2. Load avatar
    $avatarImg = [System.Drawing.Image]::FromFile($avatarSrcPath)

    # 3. Create framed circular portrait badge
    $badgeSize = 135
    $badgeX = 60
    $badgeY = 50

    $avatarBmp = New-Object System.Drawing.Bitmap $badgeSize, $badgeSize
    $gAvatar = [System.Drawing.Graphics]::FromImage($avatarBmp)
    $gAvatar.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $gAvatar.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    # Circular mask
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddEllipse(6, 6, $badgeSize - 12, $badgeSize - 12)
    $gAvatar.SetClip($path)
    $gAvatar.DrawImage($avatarImg, 0, 0, $badgeSize, $badgeSize)
    $gAvatar.ResetClip()

    # Draw gold border rings
    $goldBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 0, 0, 0))
    $goldPenOuter = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 212, 175, 55), 4)
    $goldPenInner = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 255, 223, 0), 2)
    $shadowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(140, 0, 0, 0), 5)

    # Drop shadow & avatar
    $g.DrawEllipse($shadowPen, $badgeX + 1, $badgeY + 3, $badgeSize - 2, $badgeSize - 2)
    $g.DrawImage($avatarBmp, $badgeX, $badgeY)
    $g.DrawEllipse($goldPenOuter, $badgeX + 4, $badgeY + 4, $badgeSize - 8, $badgeSize - 8)
    $g.DrawEllipse($goldPenInner, $badgeX + 6, $badgeY + 6, $badgeSize - 12, $badgeSize - 12)

    # Cleanup
    $goldBrush.Dispose()
    $goldPenOuter.Dispose()
    $goldPenInner.Dispose()
    $shadowPen.Dispose()
    $path.Dispose()
    $gAvatar.Dispose()
    $avatarBmp.Dispose()
    $avatarImg.Dispose()
    $g.Dispose()

    # Save final
    if (Test-Path $outBannerPath) { Remove-Item -Force $outBannerPath }
    $finalBmp.Save($outBannerPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $finalBmp.Dispose()

    Write-Host "Created $outBannerPath with abdullah.jpg badge!"
}
