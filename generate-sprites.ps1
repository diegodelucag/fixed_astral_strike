Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$out = Join-Path $root 'sprites'
New-Item -ItemType Directory -Force -Path $out | Out-Null

function Export-Crop($sourcePath, $name, $x, $y, $w, $h) {
  $source = [System.Drawing.Bitmap]::FromFile($sourcePath)
  $crop = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($crop)
  $dest = New-Object System.Drawing.Rectangle(0,0,$w,$h)
  $g.DrawImage($source, $dest, $x, $y, $w, $h, [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose(); $source.Dispose()
  for ($py=0; $py -lt $crop.Height; $py++) { for ($px=0; $px -lt $crop.Width; $px++) {
    $c=$crop.GetPixel($px,$py)
    if ($c.R -gt 225 -and $c.G -gt 225 -and $c.B -gt 225) { $crop.SetPixel($px,$py,[System.Drawing.Color]::FromArgb(0,$c.R,$c.G,$c.B)) }
  }}
  $crop.Save((Join-Path $out $name), [System.Drawing.Imaging.ImageFormat]::Png)
  $crop.Dispose()
}

$ships = Join-Path $root 'ships.jpg'
Export-Crop $ships 'player.png' 0 115 260 430
Export-Crop $ships 'scout.png' 0 650 280 300
Export-Crop $ships 'drone.png' 280 650 315 270
Export-Crop $ships 'turret.png' 600 650 300 300
Export-Crop $ships 'boss.png' 885 0 355 670
Export-Crop $ships 'heavy.png' 245 0 625 575
Export-Crop $ships 'carrier.png' 875 0 379 680

$fx = Join-Path $root 'FX.jpg'
Export-Crop $fx 'bolt.png' 205 0 105 205
Export-Crop $fx 'enemy-bolt.png' 0 205 120 125
Export-Crop $fx 'explosion-orange.png' 0 590 285 270
Export-Crop $fx 'explosion-purple.png' 760 590 300 270
Export-Crop $fx 'power-plus.png' 30 835 115 115
