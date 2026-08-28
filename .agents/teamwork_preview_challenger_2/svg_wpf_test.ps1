# ==============================================================================
# ACCURATE WPF NATIVE SVG PATH GEOMETRY & BOUNDS VERIFICATION
# ==============================================================================

Add-Type -AssemblyName PresentationCore, WindowsBase

Write-Host "================================================================================"
Write-Host "       EXACT MATHEMATICAL PATH BOUNDS AUDIT (WPF System.Windows.Media)          "
Write-Host "================================================================================"

$targetIcons = @(
    "icon-account.svg",
    "icon-arrow.svg",
    "icon-cart-empty.svg",
    "icon-cart.svg",
    "icon-checkmark.svg",
    "icon-lightning-bolt.svg",
    "icon-lock.svg",
    "icon-search.svg"
)

$results = @()

foreach ($iconName in $targetIcons) {
    $path = Join-Path "assets" $iconName
    $content = Get-Content $path -Raw

    $hasViewBox = $content -match 'viewBox="([^"]+)"'
    $viewBoxVal = if ($hasViewBox) { $Matches[1] } else { "0 0 0 0" }
    $vbParts = $viewBoxVal -split '\s+'
    $vbMinX = [double]$vbParts[0]
    $vbMinY = [double]$vbParts[1]
    $vbWidth = [double]$vbParts[2]
    $vbHeight = [double]$vbParts[3]
    $vbMaxX = $vbMinX + $vbWidth
    $vbMaxY = $vbMinY + $vbHeight

    $paths = [regex]::Matches($content, 'd="([^"]+)"')
    
    $overallMinX = [double]::PositiveInfinity
    $overallMinY = [double]::PositiveInfinity
    $overallMaxX = [double]::NegativeInfinity
    $overallMaxY = [double]::NegativeInfinity

    foreach ($p in $paths) {
        $d = $p.Groups[1].Value
        $geom = [System.Windows.Media.Geometry]::Parse($d)
        $b = $geom.Bounds
        if ($b.X -lt $overallMinX) { $overallMinX = $b.X }
        if ($b.Y -lt $overallMinY) { $overallMinY = $b.Y }
        if ($b.Right -gt $overallMaxX) { $overallMaxX = $b.Right }
        if ($b.Bottom -gt $overallMaxY) { $overallMaxY = $b.Bottom }
    }

    $fitsInViewBox = ($overallMinX -ge ($vbMinX - 0.001)) -and ($overallMinY -ge ($vbMinY - 0.001)) -and ($overallMaxX -le ($vbMaxX + 0.001)) -and ($overallMaxY -le ($vbMaxY + 0.001))

    $results += [PSCustomObject]@{
        Icon = $iconName
        ViewBox = ("{0}x{1}" -f $vbWidth, $vbHeight)
        GeometryBounds = ("[{0:F2}, {1:F2}] to [{2:F2}, {3:F2}]" -f $overallMinX, $overallMinY, $overallMaxX, $overallMaxY)
        FitsInViewBox = $fitsInViewBox
        PaddingLeft = ('{0:F2}' -f ($overallMinX - $vbMinX))
        PaddingRight = ('{0:F2}' -f ($vbMaxX - $overallMaxX))
        PaddingTop = ('{0:F2}' -f ($overallMinY - $vbMinY))
        PaddingBottom = ('{0:F2}' -f ($vbMaxY - $overallMaxY))
        Status = if ($fitsInViewBox) { "PASS" } else { "FAIL (CLIPPED)" }
    }
}

$results | Format-Table @{Label="Icon"; Expression={$_.Icon}; Width=24}, @{Label="ViewBox"; Expression={$_.ViewBox}; Width=10}, @{Label="Geometry Bounding Box"; Expression={$_.GeometryBounds}; Width=28}, @{Label="FitsInViewBox"; Expression={$_.FitsInViewBox}; Width=14}, @{Label="Pad(L,R,T,B)"; Expression={"($($_.PaddingLeft),$($_.PaddingRight),$($_.PaddingTop),$($_.PaddingBottom))"}; Width=20}, @{Label="Status"; Expression={$_.Status}; Width=8}
