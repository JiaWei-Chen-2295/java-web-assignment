Add-Type -AssemblyName System.Drawing

# Create static image (light blue background)
$bmp1 = New-Object System.Drawing.Bitmap(200, 150)
$g1 = [System.Drawing.Graphics]::FromImage($bmp1)
$g1.Clear([System.Drawing.Color]::LightBlue)
$font1 = New-Object System.Drawing.Font('Arial', 16)
$brush1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::DarkBlue)
$g1.DrawString('Static Image', $font1, $brush1, 30, 60)
$bmp1.Save("$PSScriptRoot\src\main\webapp\images\static-image.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$g1.Dispose()
$bmp1.Dispose()

# Create dynamic image (light green background)
$bmp2 = New-Object System.Drawing.Bitmap(200, 150)
$g2 = [System.Drawing.Graphics]::FromImage($bmp2)
$g2.Clear([System.Drawing.Color]::LightGreen)
$font2 = New-Object System.Drawing.Font('Arial', 16)
$brush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::DarkGreen)
$g2.DrawString('Dynamic Image', $font2, $brush2, 25, 60)
$bmp2.Save("$PSScriptRoot\src\main\webapp\images\dynamic-image.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$g2.Dispose()
$bmp2.Dispose()

Write-Host "Images created successfully!"
