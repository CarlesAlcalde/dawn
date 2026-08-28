Add-Type -AssemblyName PresentationCore, WindowsBase

$icons = @("icon-cart.svg", "icon-cart-empty.svg", "icon-lightning-bolt.svg", "icon-search.svg")
foreach ($icon in $icons) {
    $content = Get-Content (Join-Path "assets" $icon) -Raw
    $hasVb = $content -match 'viewBox="([^"]+)"'
    $vb = $Matches[1]
    $paths = [regex]::Matches($content, 'd="([^"]+)"')
    Write-Host "`n=== Icon: $icon | ViewBox: $vb ==="
    foreach ($p in $paths) {
        $geom = [System.Windows.Media.Geometry]::Parse($p.Groups[1].Value)
        $b = $geom.Bounds
        Write-Host ("  Path: " + $p.Groups[1].Value)
        Write-Host ("  Exact Bounds: X={0:F4}, Y={1:F4}, Width={2:F4}, Height={3:F4}, Right={4:F4}, Bottom={5:F4}" -f $b.X, $b.Y, $b.Width, $b.Height, $b.Right, $b.Bottom)
    }
}
