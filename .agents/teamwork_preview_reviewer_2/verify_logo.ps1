$logoFile = Get-Content 'snippets/velnordesk-logo.liquid' -Raw

# Test rendering variations by extracting SVG
$svgFull = [regex]::Match($logoFile, '<svg[\s\S]*?</svg>').Value
Write-Host "Full logo snippet length: $($logoFile.Length) chars"

# Check XML validity of full SVG with Liquid tags stripped/mocked
$mockedSvgFull = $logoFile -replace '\{%-?[\s\S]*?-?%\}', '' -replace '\{\{[\s\S]*?\}\}', ''
# Ensure proper SVG tag
$cleanSvg = [regex]::Match($mockedSvgFull, '<svg[\s\S]*?</svg>').Value

try {
    [xml]$xml = $cleanSvg
    Write-Host "XML Parse Succeeded for Logo SVG!"
    Write-Host "Root Element: $($xml.svg.Name)"
    Write-Host "ViewBox: $($xml.svg.viewBox)"
    Write-Host "LinearGradients: $($xml.svg.defs.linearGradient.Count)"
    Write-Host "Emblem Element Count: $($xml.svg.g.Count)"
} catch {
    Write-Host "XML Parse Failed: $($_.Exception.Message)"
}
