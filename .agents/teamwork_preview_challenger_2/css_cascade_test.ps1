# ==============================================================================
# CSS CASCADE, RESPONSIVE, OVERFLOW & LAYOUT SAFETY AUDIT
# ==============================================================================

Write-Host "================================================================================"
Write-Host "         CSS CASCADE, OVERFLOW, AND LAYOUT SHIFT AUDIT (velnordesk.css)         "
Write-Host "================================================================================"

$cssContent = Get-Content "assets\velnordesk.css" -Raw

# 1. Bracket and Comment Balance Check
$openBraces = ($cssContent.ToCharArray() | Where-Object { $_ -eq '{' }).Count
$closeBraces = ($cssContent.ToCharArray() | Where-Object { $_ -eq '}' }).Count
$bracesBalanced = ($openBraces -eq $closeBraces)

$openComments = [regex]::Matches($cssContent, '/\*').Count
$closeComments = [regex]::Matches($cssContent, '\*/').Count
$commentsBalanced = ($openComments -eq $closeComments)

Write-Host "1. Syntax & Structural Balance:"
Write-Host ("   - CSS Curly Braces Balanced: {0} ({1} open, {2} close)" -f $(if ($bracesBalanced) { "PASS" } else { "FAIL" }), $openBraces, $closeBraces)
Write-Host ("   - Comment Delimiters Balanced: {0} ({1} open, {2} close)" -f $(if ($commentsBalanced) { "PASS" } else { "FAIL" }), $openComments, $closeComments)

# 2. Variable Reference Resolution Check
Write-Host "`n2. CSS Custom Property (Variable) Resolution Check:"
$varDefs = [regex]::Matches($cssContent, '--([a-zA-Z0-9_-]+)\s*:') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$varRefs = [regex]::Matches($cssContent, 'var\(--([a-zA-Z0-9_-]+)[,\)]') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique

# Known Shopify Dawn global variables
$dawnGlobalVars = @('color-background', 'color-foreground', 'color-button', 'color-button-text', 'color-secondary-button-text', 'page-width', 'font-heading-family', 'font-body-family', 'buttons-radius', 'inputs-radius', 'card-corner-radius')

$unresolvedVars = @()
foreach ($ref in $varRefs) {
    if ($varDefs -notcontains $ref -and $dawnGlobalVars -notcontains $ref) {
        $unresolvedVars += $ref
    }
}

if ($unresolvedVars.Count -eq 0) {
    Write-Host "   - All $($varRefs.Count) CSS variable references resolve cleanly to brand tokens or Dawn globals: PASS"
} else {
    Write-Host "   - WARNING: Unresolved variable references found: $($unresolvedVars -join ', ')"
}

# 3. Interactive Overlay Pointer-Events Safety Check
Write-Host "`n3. Overlay & Pseudo-Element Clickability / Pointer-Events Audit:"
$overlays = @(
    @{ Name = "body::after (CRT Scanline)"; Pattern = 'body::after\s*\{[^}]*pointer-events:\s*none' },
    @{ Name = ".button::before (Glow Sheen)"; Pattern = '\.button::before[^\{]*\{[^}]*pointer-events:\s*none' },
    @{ Name = ".color-scheme-3/4::before (HUD Matrix)"; Pattern = '\.color-scheme-3::before[^\{]*\{[^}]*pointer-events:\s*none' },
    @{ Name = ".vd-tilt-glare (Card Glare)"; Pattern = '\.vd-tilt-glare\s*\{[^}]*pointer-events:\s*none' },
    @{ Name = ".vd-scroll-progress (Scroll Bar)"; Pattern = '\.vd-scroll-progress\s*\{[^}]*pointer-events:\s*none' },
    @{ Name = ".vd-cursor (Cursor Elements)"; Pattern = '\.vd-cursor\s*\{[^}]*pointer-events:\s*none' }
)

foreach ($ov in $overlays) {
    $hasPointerNone = $cssContent -match $ov.Pattern
    Write-Host ("   - {0,-45}: {1}" -f $ov.Name, $(if ($hasPointerNone) { "PASS (pointer-events: none secured)" } else { "FAIL (May block user clicks)" }))
}

# 4. Overflow & Horizontal Scrollbar Risk Audit
Write-Host "`n4. Horizontal Overflow & Fixed Width Hazards Audit:"
$vwMatches = [regex]::Matches($cssContent, '[^;\{\}]+100vw[^;\{\}]*;')
Write-Host "   - Rules using 100vw:"
foreach ($m in $vwMatches) {
    Write-Host ("     * Rule: {0}" -f $m.Value.Trim())
}

# Check for unconstrained large fixed pixel widths (> 800px without max-width)
$fixedWidths = [regex]::Matches($cssContent, 'width:\s*([0-9]+)px')
$dangerousWidths = @()
foreach ($fw in $fixedWidths) {
    $px = [int]$fw.Groups[1].Value
    if ($px -gt 400) {
        $dangerousWidths += $px
    }
}
if ($dangerousWidths.Count -eq 0) {
    Write-Host "   - No dangerous hardcoded large pixel widths (> 400px) found: PASS"
} else {
    Write-Host "   - Large fixed pixel widths found: $($dangerousWidths -join ', ')"
}

# 5. Accessibility & Motion Preference Support
Write-Host "`n5. Accessibility & Reduced Motion Support:"
$hasReducedMotion = $cssContent -match '@media\s*\(\s*prefers-reduced-motion:\s*reduce\s*\)'
Write-Host ("   - Prefers-reduced-motion media query present: {0}" -f $(if ($hasReducedMotion) { "PASS" } else { "FAIL" }))

# 6. Typography Import Verification
Write-Host "`n6. Web Font Loading Audit:"
$hasFontImport = $cssContent -match "@import\s+url\('https:\/\/fonts\.googleapis\.com\/css2\?family=Inter:wght@300;400;500;600;700&family=Space\+Grotesk:wght@400;500;600;700;800&family=Space\+Mono:[^']*display=swap'\);"
Write-Host ("   - Google Fonts @import with display=swap (Inter, Space Grotesk, Space Mono): {0}" -f $(if ($hasFontImport) { "PASS" } else { "FAIL" }))

# 7. Liquid Theme Insertion Check
Write-Host "`n7. Master Layout Integration Audit (layout/theme.liquid):"
$themeLiquid = Get-Content "layout\theme.liquid" -Raw
$hasVelnordeskCss = $themeLiquid -match "\{\{\s*'velnordesk\.css'\s*\|\s*asset_url\s*\|\s*stylesheet_tag\s*\}\}"
$loadsAfterBase = $false
if ($hasVelnordeskCss) {
    $baseIdx = $themeLiquid.IndexOf("base.css")
    $vdIdx = $themeLiquid.IndexOf("velnordesk.css")
    $loadsAfterBase = ($baseIdx -ge 0 -and $vdIdx -gt $baseIdx)
}
Write-Host ("   - velnordesk.css linked in layout/theme.liquid: {0}" -f $(if ($hasVelnordeskCss) { "PASS" } else { "FAIL" }))
Write-Host ("   - velnordesk.css cascades AFTER base.css: {0}" -f $(if ($loadsAfterBase) { "PASS" } else { "FAIL" }))
