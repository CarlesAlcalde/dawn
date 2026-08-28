function Get-RelativeLuminance($hex) {
    $hex = $hex.TrimStart('#')
    if ($hex.Length -eq 3) {
        $hex = "$($hex[0])$($hex[0])$($hex[1])$($hex[1])$($hex[2])$($hex[2])"
    }
    $r = [Convert]::ToInt32($hex.Substring(0, 2), 16) / 255.0
    $g = [Convert]::ToInt32($hex.Substring(2, 2), 16) / 255.0
    $b = [Convert]::ToInt32($hex.Substring(4, 2), 16) / 255.0

    $rLin = if ($r -le 0.04045) { $r / 12.92 } else { [Math]::Pow(($r + 0.055) / 1.055, 2.4) }
    $gLin = if ($g -le 0.04045) { $g / 12.92 } else { [Math]::Pow(($g + 0.055) / 1.055, 2.4) }
    $bLin = if ($b -le 0.04045) { $b / 12.92 } else { [Math]::Pow(($b + 0.055) / 1.055, 2.4) }

    return (0.2126 * $rLin) + (0.7152 * $gLin) + (0.0722 * $bLin)
}

function Get-ContrastRatio($hex1, $hex2) {
    $l1 = Get-RelativeLuminance $hex1
    $l2 = Get-RelativeLuminance $hex2
    $brightest = [Math]::Max($l1, $l2)
    $darkest = [Math]::Min($l1, $l2)
    return ($brightest + 0.05) / ($darkest + 0.05)
}

$rawJson = Get-Content "config\settings_data.json" -Raw
$cleanJson = $rawJson -replace '(?s)/\*.*?\*/', ''
$settings = $cleanJson | ConvertFrom-Json

Write-Host "================================================================================"
Write-Host "               WCAG 2.1 CONTRAST AUDIT ACROSS ALL COLOR SCHEMES                 "
Write-Host "================================================================================"

$schemeList = @('scheme-1', 'scheme-2', 'scheme-3', 'scheme-4', 'scheme-5')

foreach ($name in $schemeList) {
    $s = $settings.current.color_schemes.$name.settings

    $bg = $s.background
    $text = $s.text
    $btn = $s.button
    $btnLabel = $s.button_label
    $secBtnLabel = $s.secondary_button_label

    $crText = Get-ContrastRatio $text $bg
    $crBtn = Get-ContrastRatio $btnLabel $btn
    $crSecBtn = Get-ContrastRatio $secBtnLabel $bg
    $crBtnVsBg = Get-ContrastRatio $btn $bg

    $wcagText = if ($crText -ge 7.0) { "AAA (>= 7.0:1)" } elseif ($crText -ge 4.5) { "AA (>= 4.5:1)" } elseif ($crText -ge 3.0) { "AA Large (>= 3.0:1)" } else { "FAIL (< 3.0:1)" }
    $wcagBtn = if ($crBtn -ge 7.0) { "AAA (>= 7.0:1)" } elseif ($crBtn -ge 4.5) { "AA (>= 4.5:1)" } elseif ($crBtn -ge 3.0) { "AA Large / UI (>= 3.0:1)" } else { "FAIL (< 3.0:1)" }
    $wcagSecBtn = if ($crSecBtn -ge 7.0) { "AAA (>= 7.0:1)" } elseif ($crSecBtn -ge 4.5) { "AA (>= 4.5:1)" } elseif ($crSecBtn -ge 3.0) { "AA Large / UI (>= 3.0:1)" } else { "FAIL (< 3.0:1)" }

    Write-Host "`n>>> Scheme: $name <<<"
    Write-Host ("  Background            : {0}" -f $bg)
    Write-Host ("  Text on Background    : {0} on {1} -> CR = {2:F2}:1 [{3}]" -f $text, $bg, $crText, $wcagText)
    Write-Host ("  Button Label on Button: {0} on {1} -> CR = {2:F2}:1 [{3}]" -f $btnLabel, $btn, $crBtn, $wcagBtn)
    Write-Host ("  Sec Button on Bg      : {0} on {1} -> CR = {2:F2}:1 [{3}]" -f $secBtnLabel, $bg, $crSecBtn, $wcagSecBtn)
    Write-Host ("  Button vs Bg (UI boundary): {0} on {1} -> CR = {2:F2}:1" -f $btn, $bg, $crBtnVsBg)
}

Write-Host "`n================================================================================"
Write-Host "               ADDITIONAL UI BRAND TOKEN CONTRAST CHECKS                        "
Write-Host "================================================================================"

$customChecks = @(
    @{ Name = "Cyber Primary Button (Dark text #0A0D14 on Cyber Cyan #00F0FF)"; Foreground = "#0A0D14"; Background = "#00F0FF" },
    @{ Name = "Cyber Primary Button (Dark text #0A0D14 on Electric Blue #0066FF)"; Foreground = "#0A0D14"; Background = "#0066FF" },
    @{ Name = "Cyber Primary Button (White text #FFFFFF on Electric Blue #0066FF)"; Foreground = "#FFFFFF"; Background = "#0066FF" },
    @{ Name = "Cyber Primary Button (White text #FFFFFF on Electric Violet #8B5CF6)"; Foreground = "#FFFFFF"; Background = "#8B5CF6" },
    @{ Name = "Badge Text (Cyber Cyan #00F0FF on Dark Surface #0A0D14)"; Foreground = "#00F0FF"; Background = "#0A0D14" },
    @{ Name = "Badge Text (Violet #C4B5FD on Dark Surface #0A0D14)"; Foreground = "#C4B5FD"; Background = "#0A0D14" },
    @{ Name = "Cart Count Bubble (Obsidian #0A0D14 on Cyan #00F0FF)"; Foreground = "#0A0D14"; Background = "#00F0FF" },
    @{ Name = "Price Sale Text (Cyan #00F0FF on Obsidian #0A0D14)"; Foreground = "#00F0FF"; Background = "#0A0D14" },
    @{ Name = "Price Regular Muted (Slate #64748B on Obsidian #0A0D14)"; Foreground = "#64748B"; Background = "#0A0D14" },
    @{ Name = "Price Regular Muted (Slate #64748B on Light #FFFFFF)"; Foreground = "#64748B"; Background = "#FFFFFF" },
    @{ Name = "Eyebrow / Subtitle (Cyan #00F0FF on Dark Navy #121824)"; Foreground = "#00F0FF"; Background = "#121824" },
    @{ Name = "Eyebrow / Subtitle (Cyan #00F0FF on Electric Accent #0F172A)"; Foreground = "#00F0FF"; Background = "#0F172A" }
)

foreach ($chk in $customChecks) {
    $cr = Get-ContrastRatio $chk.Foreground $chk.Background
    $status = if ($cr -ge 7.0) { "AAA (>= 7.0:1)" } elseif ($cr -ge 4.5) { "AA (>= 4.5:1)" } elseif ($cr -ge 3.0) { "AA Large / UI (>= 3.0:1)" } else { "FAIL (< 3.0:1)" }
    Write-Host ("  {0,-65} : {1,7:F2}:1 [{2}]" -f $chk.Name, $cr, $status)
}
