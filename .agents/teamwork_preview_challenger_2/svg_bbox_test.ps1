# ==============================================================================
# RIGOROUS SVG PATH INTERPRETER & BOUNDING BOX TEST
# ==============================================================================

function Get-SvgPathBoundingBox($d) {
    # Tokenize path commands and coordinates
    # Match command letter followed by coordinates
    $tokens = [regex]::Matches($d, '([a-df-zA-DF-Z])|([-+]?[0-9]*\.?[0-9]+)')
    
    $cx = 0.0
    $cy = 0.0
    $sx = 0.0
    $sy = 0.0
    
    $minX = [double]::PositiveInfinity
    $minY = [double]::PositiveInfinity
    $maxX = [double]::NegativeInfinity
    $maxY = [double]::NegativeInfinity
    
    $currentCmd = ''
    $numList = New-Object System.Collections.Generic.List[double]
    
    function Update-Bounds($x, $y) {
        if ($x -lt $script:minX) { $script:minX = $x }
        if ($x -gt $script:maxX) { $script:maxX = $x }
        if ($y -lt $script:minY) { $script:minY = $y }
        if ($y -gt $script:maxY) { $script:maxY = $y }
    }
    
    $i = 0
    while ($i -lt $tokens.Count) {
        $token = $tokens[$i].Value
        if ($token -match '^[a-zA-Z]$') {
            $cmd = $token
            $i++
            switch ($cmd) {
                'M' {
                    $cx = [double]$tokens[$i].Value; $cy = [double]$tokens[$i+1].Value
                    $sx = $cx; $sy = $cy
                    Update-Bounds $cx $cy
                    $i += 2
                    # Subsequent coordinates are treated as L
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        $cx = [double]$tokens[$i].Value; $cy = [double]$tokens[$i+1].Value
                        Update-Bounds $cx $cy
                        $i += 2
                    }
                }
                'm' {
                    $cx += [double]$tokens[$i].Value; $cy += [double]$tokens[$i+1].Value
                    $sx = $cx; $sy = $cy
                    Update-Bounds $cx $cy
                    $i += 2
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        $cx += [double]$tokens[$i].Value; $cy += [double]$tokens[$i+1].Value
                        Update-Bounds $cx $cy
                        $i += 2
                    }
                }
                'L' {
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        $cx = [double]$tokens[$i].Value; $cy = [double]$tokens[$i+1].Value
                        Update-Bounds $cx $cy
                        $i += 2
                    }
                }
                'l' {
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        $cx += [double]$tokens[$i].Value; $cy += [double]$tokens[$i+1].Value
                        Update-Bounds $cx $cy
                        $i += 2
                    }
                }
                'H' {
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        $cx = [double]$tokens[$i].Value
                        Update-Bounds $cx $cy
                        $i++
                    }
                }
                'h' {
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        $cx += [double]$tokens[$i].Value
                        Update-Bounds $cx $cy
                        $i++
                    }
                }
                'V' {
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        $cy = [double]$tokens[$i].Value
                        Update-Bounds $cx $cy
                        $i++
                    }
                }
                'v' {
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        $cy += [double]$tokens[$i].Value
                        Update-Bounds $cx $cy
                        $i++
                    }
                }
                'A' {
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        # rx, ry, rot, large, sweep, x, y
                        $cx = [double]$tokens[$i+5].Value; $cy = [double]$tokens[$i+6].Value
                        Update-Bounds $cx $cy
                        $i += 7
                    }
                }
                'a' {
                    while ($i -lt $tokens.Count -and -not ($tokens[$i].Value -match '^[a-zA-Z]$')) {
                        # rx, ry, rot, large, sweep, dx, dy
                        $cx += [double]$tokens[$i+5].Value; $cy += [double]$tokens[$i+6].Value
                        Update-Bounds $cx $cy
                        $i += 7
                    }
                }
                'Z' { $cx = $sx; $cy = $sy }
                'z' { $cx = $sx; $cy = $sy }
                default { $i++ }
            }
        } else {
            $i++
        }
    }
    
    return [PSCustomObject]@{
        MinX = $script:minX
        MinY = $script:minY
        MaxX = $script:maxX
        MaxY = $script:maxY
    }
}

Write-Host "================================================================================"
Write-Host "             RIGOROUS SVG BOUNDING BOX VS VIEWBOX VERIFICATION                  "
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
    $pathMinX = 9999.0; $pathMinY = 9999.0; $pathMaxX = -9999.0; $pathMaxY = -9999.0

    foreach ($p in $paths) {
        $bb = Get-SvgPathBoundingBox $p.Groups[1].Value
        if ($bb.MinX -lt $pathMinX) { $pathMinX = $bb.MinX }
        if ($bb.MinY -lt $pathMinY) { $pathMinY = $bb.MinY }
        if ($bb.MaxX -gt $pathMaxX) { $pathMaxX = $bb.MaxX }
        if ($bb.MaxY -gt $pathMaxY) { $pathMaxY = $bb.MaxY }
    }

    $withinBounds = ($pathMinX -ge $vbMinX - 0.01) -and ($pathMinY -ge $vbMinY - 0.01) -and ($pathMaxX -le $vbMaxX + 0.01) -and ($pathMaxY -le $vbMaxY + 0.01)

    $results += [PSCustomObject]@{
        Icon = $iconName
        ViewBox = "$vbMinX $vbMinY $vbWidth $vbHeight"
        PathBounds = ("[{0:F1}, {1:F1}] to [{2:F1}, {3:F1}]" -f $pathMinX, $pathMinY, $pathMaxX, $pathMaxY)
        FitsInViewBox = $withinBounds
        Status = if ($withinBounds) { "PASS" } else { "CLIPPED" }
    }
}

$results | Format-Table @{Label="Icon"; Expression={$_.Icon}; Width=25}, @{Label="ViewBox"; Expression={$_.ViewBox}; Width=16}, @{Label="Path Geometry Bounds"; Expression={$_.PathBounds}; Width=30}, @{Label="FitsInViewBox"; Expression={$_.FitsInViewBox}; Width=15}, @{Label="Status"; Expression={$_.Status}; Width=10}
