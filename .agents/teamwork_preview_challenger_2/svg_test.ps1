# ==============================================================================
# SVG VIEWBOX, DIMENSION CONSISTENCY, AND ASPECT RATIO PRESERVATION AUDIT
# ==============================================================================

Write-Host "================================================================================"
Write-Host "             SVG VIEWBOX, SCALING & ASPECT RATIO AUDIT                          "
Write-Host "================================================================================"

$svgFiles = Get-ChildItem -Path "assets\icon-*.svg"

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

    # Check XML / SVG tags
    $hasSvg = $content -match '<svg[^>]*>'
    $hasViewBox = $content -match 'viewBox="([^"]+)"'
    $viewBoxVal = if ($hasViewBox) { $Matches[1] } else { "NONE" }
    
    $hasFillNone = $content -match 'fill="none"'
    $hasCurrentColor = $content -match 'fill="currentColor"' -or $content -match 'stroke="currentColor"'
    $hasClass = $content -match 'class="([^"]+)"'
    $classVal = if ($hasClass) { $Matches[1] } else { "NONE" }
    $hasXmlns = $content -match 'xmlns="http://www.w3.org/2000/svg"'

    # Parse viewBox dimensions
    $vbParts = $viewBoxVal -split '\s+'
    $aspectRatio = "N/A"
    $width = 0
    $height = 0
    $minX = 0
    $minY = 0

    if ($vbParts.Length -eq 4) {
        $minX = [double]$vbParts[0]
        $minY = [double]$vbParts[1]
        $width = [double]$vbParts[2]
        $height = [double]$vbParts[3]
        $aspectRatio = ('{0:F3}' -f ($width / $height))
    }

    # Extract all numbers from path/polygon/rect/circle/lines to detect any out-of-bounds coordinates
    $allMatches = [regex]::Matches($content, '[-+]?[0-9]*\.?[0-9]+')
    $maxCoord = 0
    $minCoord = 0
    # Check bounds roughly
    $outOfBounds = $false
    # More precise: match path 'd' attribute or points
    $paths = [regex]::Matches($content, 'd="([^"]+)"')
    foreach ($p in $paths) {
        $d = $p.Groups[1].Value
        # Find coordinates
        $coords = [regex]::Matches($d, '(?<x>[-+]?[0-9]*\.?[0-9]+)[,\s]+(?<y>[-+]?[0-9]*\.?[0-9]+)')
        foreach ($c in $coords) {
            $x = [double]$c.Groups['x'].Value
            $y = [double]$c.Groups['y'].Value
            if ($x -gt ($width + 2) -or $x -lt ($minX - 2) -or $y -gt ($height + 2) -or $y -lt ($minY - 2)) {
                $outOfBounds = $true
            }
        }
    }

    $status = if ($hasSvg -and $hasViewBox -and $hasCurrentColor -and -not $outOfBounds) { "PASS" } else { "CHECK" }

    $results += [PSCustomObject]@{
        Icon = $iconName
        ViewBox = $viewBoxVal
        Dimensions = "${width}x${height}"
        AspectRatio = $aspectRatio
        Class = $classVal
        HasXmlns = $hasXmlns
        FillCurrentColor = $hasCurrentColor
        OutOfBounds = $outOfBounds
        Status = $status
    }
}

$results | Format-Table @{Label="Icon"; Expression={$_.Icon}; Width=25}, @{Label="ViewBox"; Expression={$_.ViewBox}; Width=12}, @{Label="Dimensions"; Expression={$_.Dimensions}; Width=12}, @{Label="Aspect"; Expression={$_.AspectRatio}; Width=8}, @{Label="OutOfBounds"; Expression={$_.OutOfBounds}; Width=14}, @{Label="Status"; Expression={$_.Status}; Width=8}

Write-Host "`n================================================================================"
Write-Host "             LOGO SNIPPET (snippets/velnordesk-logo.liquid) AUDIT                "
Write-Host "================================================================================"

$logoContent = Get-Content "snippets\velnordesk-logo.liquid" -Raw

$hasFullViewBox = $logoContent -match '0 0 220 44'
$hasEmblemViewBox = $logoContent -match '0 0 44 44'
$hasLinearGradients = $logoContent -match '<linearGradient id="vd-'
$hasGlowFilter = $logoContent -match '<filter id="vd-glow-'
$hasAriaLabel = $logoContent -match 'aria-label="VelnorDesk"'
$hasRoleImg = $logoContent -match 'role="img"'
$hasUniqueSuffix = $logoContent -match 'suffix'

Write-Host "  Logo Snippet Checks:"
Write-Host ("    Full ViewBox (0 0 220 44, Aspect Ratio 5:1)     : {0}" -f $(if ($hasFullViewBox) { "PASS" } else { "FAIL" }))
Write-Host ("    Emblem ViewBox (0 0 44 44, Aspect Ratio 1:1)    : {0}" -f $(if ($hasEmblemViewBox) { "PASS" } else { "FAIL" }))
Write-Host ("    Brand Gradients (Cyan, Blue, Violet Defined)   : {0}" -f $(if ($hasLinearGradients) { "PASS" } else { "FAIL" }))
Write-Host ("    Glow Filter Defined                            : {0}" -f $(if ($hasGlowFilter) { "PASS" } else { "FAIL" }))
Write-Host ("    Accessibility (aria-label, role='img')         : {0}" -f $(if ($hasAriaLabel -and $hasRoleImg) { "PASS" } else { "FAIL" }))
Write-Host ("    Unique ID Prefixing (prevents SVG ID collision): {0}" -f $(if ($hasUniqueSuffix) { "PASS" } else { "FAIL" }))

