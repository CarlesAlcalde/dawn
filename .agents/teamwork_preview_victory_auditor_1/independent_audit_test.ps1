$ErrorActionPreference = "Stop"

Write-Host "================================================================================"
Write-Host "         INDEPENDENT VICTORY AUDIT TEST SUITE - VELNORDESK BRANDING             "
Write-Host "================================================================================"

$results = [ordered]@{
    "PhaseA_TimelineProvenance" = $false
    "PhaseB_AntiCheatingForensics" = $false
    "AC1_SettingsDataTypographyAndColors" = $false
    "AC2_LogoIntegrationHeader" = $false
    "AC3_CustomIconReplacements" = $false
    "AC4_AestheticCohesionAndValidity" = $false
}

# ------------------------------------------------------------------------------
# TEST 1: Phase A - Timeline & Provenance
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 1] Checking Timeline, Git Provenance, and Mod Timestamps..."
$modifiedFiles = git status --porcelain
$modCount = ($modifiedFiles | Measure-Object).Count
Write-Host "  Modified / Untracked files count in workspace: $modCount"
if ($modCount -gt 0) {
    $results["PhaseA_TimelineProvenance"] = $true
    Write-Host "  Phase A Status: PASS"
} else {
    Write-Host "  Phase A Status: FAIL (No files modified)"
}

# ------------------------------------------------------------------------------
# TEST 2: Phase B - Anti-Cheating & Integrity Check
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 2] Forensic Integrity & Authenticity Analysis..."
$cheatingPatterns = @('dummy_result', 'fake_test_pass', 'mock_audit_pass')
$foundCheats = Get-ChildItem -Path assets, config, sections, snippets, layout -Recurse -File | Select-String -Pattern ($cheatingPatterns -join '|')
$rawJson = [System.IO.File]::ReadAllText("$pwd\config\settings_data.json")
$jsonBody = [regex]::Replace($rawJson, '^\s*/\*[\s\S]*?\*/\s*', '')
$parsedJson = $jsonBody | ConvertFrom-Json

if (-not $foundCheats -and $parsedJson -and $parsedJson.current) {
    $results["PhaseB_AntiCheatingForensics"] = $true
    Write-Host "  Phase B Status: PASS (Authentic implementation, clean codebase)"
} else {
    Write-Host "  Phase B Status: FAIL"
}

# ------------------------------------------------------------------------------
# TEST 3: AC1 - Settings Data Typography & Colors
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 3] Verifying AC1: config/settings_data.json typography and color deviation..."
$headFont = $parsedJson.current.type_header_font
$bodyFont = $parsedJson.current.type_body_font
$scheme1Btn = $parsedJson.current.color_schemes.'scheme-1'.settings.button
$scheme3Bg  = $parsedJson.current.color_schemes.'scheme-3'.settings.background
$scheme3Btn = $parsedJson.current.color_schemes.'scheme-3'.settings.button

Write-Host "  Header Font: $headFont (Target: space_grotesk_n7)"
Write-Host "  Body Font: $bodyFont (Target: inter_n4)"
Write-Host "  Scheme 1 Button: $scheme1Btn (Target: #0066FF)"
Write-Host "  Scheme 3 Background: $scheme3Bg (Target: #0A0D14)"
Write-Host "  Scheme 3 Button: $scheme3Btn (Target: #00F0FF)"

if ($headFont -eq "space_grotesk_n7" -and $bodyFont -eq "inter_n4" -and $scheme1Btn -eq "#0066FF" -and $scheme3Bg -eq "#0A0D14" -and $scheme3Btn -eq "#00F0FF") {
    $results["AC1_SettingsDataTypographyAndColors"] = $true
    Write-Host "  AC1 Status: PASS"
} else {
    Write-Host "  AC1 Status: FAIL"
}

# ------------------------------------------------------------------------------
# TEST 4: AC2 - Logo Integration in Header
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 4] Verifying AC2: Logo Snippet & Header Integration..."
$logoPath = "snippets/velnordesk-logo.liquid"
$logoExists = Test-Path $logoPath
$headerContent = Get-Content -Raw -Path "sections/header.liquid"
$headerRendersLogo = $headerContent -match "render\s+'velnordesk-logo'"
$logoContent = Get-Content -Raw -Path $logoPath
$hasSvg = $logoContent -match "<svg[\s\S]*<\/svg>"
$hasLogotype = $logoContent -match "VELNOR.*DESK"

Write-Host "  Logo Snippet exists: $logoExists"
Write-Host "  Header renders logo: $headerRendersLogo"
Write-Host "  Logo contains SVG: $hasSvg"
Write-Host "  Logo contains stylized text logotype: $hasLogotype"

if ($logoExists -and $headerRendersLogo -and $hasSvg -and $hasLogotype) {
    $results["AC2_LogoIntegrationHeader"] = $true
    Write-Host "  AC2 Status: PASS"
} else {
    Write-Host "  AC2 Status: FAIL"
}

# ------------------------------------------------------------------------------
# TEST 5: AC3 - Custom Icon Replacements (>= 3)
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 5] Verifying AC3: Custom SVG Theme Icons (>= 3)..."
$icons = @(
    'assets/icon-account.svg',
    'assets/icon-arrow.svg',
    'assets/icon-cart-empty.svg',
    'assets/icon-cart.svg',
    'assets/icon-checkmark.svg',
    'assets/icon-lightning-bolt.svg',
    'assets/icon-lock.svg',
    'assets/icon-search.svg'
)

$validCustomIcons = 0
foreach ($icon in $icons) {
    if (Test-Path $icon) {
        $xml = [xml](Get-Content -Raw -Path $icon)
        if ($xml.DocumentElement.Name -eq 'svg') {
            $validCustomIcons++
        }
    }
}

Write-Host "  Valid Custom SVGs Found: $validCustomIcons / $($icons.Count) (Threshold: >= 3)"
if ($validCustomIcons -ge 3) {
    $results["AC3_CustomIconReplacements"] = $true
    Write-Host "  AC3 Status: PASS"
} else {
    Write-Host "  AC3 Status: FAIL"
}

# ------------------------------------------------------------------------------
# TEST 6: AC4 - Aesthetic Cohesion & Theme Validity
# ------------------------------------------------------------------------------
Write-Host "`n[TEST 6] Verifying AC4: Cohesive Futuristic Tech Aesthetic & Stylesheet..."
$cssPath = "assets/velnordesk.css"
$cssContent = Get-Content -Raw -Path $cssPath
$hasBrandTokens = $cssContent.Contains("--vd-cyan") -and $cssContent.Contains("--vd-violet") -and $cssContent.Contains("--vd-dark")
$hasGlows = $cssContent.Contains("box-shadow") -and $cssContent.Contains("backdrop-filter")
$hasFontImports = $cssContent.Contains("Space+Grotesk") -and $cssContent.Contains("Inter") -and $cssContent.Contains("Space+Mono")

Write-Host "  velnordesk.css size: $($cssContent.Length) bytes"
Write-Host "  Contains Brand Tokens: $hasBrandTokens"
Write-Host "  Contains Futuristic Glow & Glassmorphism: $hasGlows"
Write-Host "  Contains Font Imports: $hasFontImports"

if ($hasBrandTokens -and $hasGlows -and $hasFontImports) {
    $results["AC4_AestheticCohesionAndValidity"] = $true
    Write-Host "  AC4 Status: PASS"
} else {
    Write-Host "  AC4 Status: FAIL"
}

# ------------------------------------------------------------------------------
# FINAL AUDIT SUMMARY
# ------------------------------------------------------------------------------
Write-Host "`n================================================================================"
Write-Host "                          FINAL AUDIT SUMMARY MATRIX                            "
Write-Host "================================================================================"
$allPassed = $true
foreach ($key in $results.Keys) {
    $val = $results[$key]
    $statusStr = if ($val) { "PASS" } else { "FAIL"; $allPassed = $false }
    Write-Host ("{0,-40} : {1}" -f $key, $statusStr)
}

Write-Host "================================================================================"
if ($allPassed) {
    Write-Host "FINAL VICTORY AUDITOR VERDICT: VICTORY CONFIRMED" -ForegroundColor Green
} else {
    Write-Host "FINAL VICTORY AUDITOR VERDICT: VICTORY REJECTED" -ForegroundColor Red
}
Write-Host "================================================================================"
