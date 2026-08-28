# ==============================================================================
# MASTER VERIFICATION & ADVERSARIAL CHALLENGER HARNESS
# ==============================================================================

Write-Host "================================================================================"
Write-Host "  VELNORDESK BRANDING ADVERSARIAL VERIFICATION HARNESS (CHALLENGER 2)           "
Write-Host "================================================================================"

Write-Host "`n>>> [SUITE 1/4] RUNNING WCAG 2.1 COLOR CONTRAST & ACCESSIBILITY AUDIT..."
powershell -NoProfile -ExecutionPolicy Bypass -File ".agents\teamwork_preview_challenger_2\contrast_test.ps1"

Write-Host "`n>>> [SUITE 2/4] RUNNING SVG VIEWBOX & EXACT GEOMETRIC BOUNDS AUDIT..."
powershell -NoProfile -ExecutionPolicy Bypass -File ".agents\teamwork_preview_challenger_2\svg_wpf_test.ps1"

Write-Host "`n>>> [SUITE 3/4] RUNNING REQUIREMENT R3 ICON REPLACEMENT & DEVIATION AUDIT..."
powershell -NoProfile -ExecutionPolicy Bypass -File ".agents\teamwork_preview_challenger_2\r3_icon_verification.ps1"

Write-Host "`n>>> [SUITE 4/4] RUNNING CSS CASCADE, OVERFLOW & LAYOUT SAFETY AUDIT..."
powershell -NoProfile -ExecutionPolicy Bypass -File ".agents\teamwork_preview_challenger_2\css_cascade_test.ps1"

Write-Host "`n>>> RUNNING LIQUID SYNTAX & TEMPLATE INTEGRITY AUDIT..."
powershell -NoProfile -ExecutionPolicy Bypass -File ".agents\teamwork_preview_challenger_2\liquid_test.ps1"

Write-Host "`n================================================================================"
Write-Host "                      ALL AUDITS COMPLETED EMPIRICALLY                          "
Write-Host "================================================================================"
