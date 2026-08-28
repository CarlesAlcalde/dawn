# ==============================================================================
# LIQUID SYNTAX & TEMPLATE INTEGRITY AUDIT
# ==============================================================================

Write-Host "================================================================================"
Write-Host "               LIQUID TEMPLATE SYNTAX & INTEGRITY AUDIT                         "
Write-Host "================================================================================"

$liquidFiles = @(
    "layout\theme.liquid",
    "sections\header.liquid",
    "sections\footer.liquid",
    "snippets\velnordesk-logo.liquid"
)

foreach ($f in $liquidFiles) {
    $content = Get-Content $f -Raw
    
    # Check if tags balance
    $ifMatches = [regex]::Matches($content, '\{%-?\s*if\s+')
    $endifMatches = [regex]::Matches($content, '\{%-?\s*endif\s*-?%\}')
    $unlessMatches = [regex]::Matches($content, '\{%-?\s*unless\s+')
    $endunlessMatches = [regex]::Matches($content, '\{%-?\s*endunless\s*-?%\}')
    $forMatches = [regex]::Matches($content, '\{%-?\s*for\s+')
    $endforMatches = [regex]::Matches($content, '\{%-?\s*endfor\s*-?%\}')
    $caseMatches = [regex]::Matches($content, '\{%-?\s*case\s+')
    $endcaseMatches = [regex]::Matches($content, '\{%-?\s*endcase\s*-?%\}')
    
    # Check render tag for velnordesk-logo
    $rendersLogo = $content -match "render\s+'velnordesk-logo'"
    
    Write-Host "`nFile: $f"
    Write-Host ("  - if / endif balance     : {0} ({1} vs {2})" -f $(if ($ifMatches.Count -eq $endifMatches.Count) { "PASS" } else { "FAIL" }), $ifMatches.Count, $endifMatches.Count)
    Write-Host ("  - unless/endunless balance: {0} ({1} vs {2})" -f $(if ($unlessMatches.Count -eq $endunlessMatches.Count) { "PASS" } else { "FAIL" }), $unlessMatches.Count, $endunlessMatches.Count)
    Write-Host ("  - for / endfor balance   : {0} ({1} vs {2})" -f $(if ($forMatches.Count -eq $endforMatches.Count) { "PASS" } else { "FAIL" }), $forMatches.Count, $endforMatches.Count)
    Write-Host ("  - case / endcase balance : {0} ({1} vs {2})" -f $(if ($caseMatches.Count -eq $endcaseMatches.Count) { "PASS" } else { "FAIL" }), $caseMatches.Count, $endcaseMatches.Count)
    if ($f -match 'header|footer') {
        Write-Host ("  - renders 'velnordesk-logo': {0}" -f $(if ($rendersLogo) { "PASS" } else { "FAIL" }))
    }
}
