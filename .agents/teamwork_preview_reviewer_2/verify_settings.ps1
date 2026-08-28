$jsonRaw = Get-Content 'config/settings_data.json' -Raw
$d = $jsonRaw | ConvertFrom-Json

Write-Host "=== CURRENT SETTINGS ==="
Write-Host "Header Font: $($d.current.type_header_font)"
Write-Host "Body Font: $($d.current.type_body_font)"
Write-Host "Heading Scale: $($d.current.heading_scale)"
Write-Host "Body Scale: $($d.current.body_scale)"

Write-Host "`n=== COLOR SCHEMES (CURRENT) ==="
foreach ($prop in $d.current.color_schemes.PSObject.Properties) {
    $s = $prop.Value.settings
    Write-Host "$($prop.Name): background=$($s.background), text=$($s.text), button=$($s.button), button_label=$($s.button_label), sec_btn=$($s.secondary_button_label), shadow=$($s.shadow)"
}

Write-Host "`n=== PRESETS.DAWN SETTINGS ==="
Write-Host "Header Font: $($d.presets.Dawn.type_header_font)"
Write-Host "Body Font: $($d.presets.Dawn.type_body_font)"
Write-Host "Heading Scale: $($d.presets.Dawn.heading_scale)"
Write-Host "Body Scale: $($d.presets.Dawn.body_scale)"

Write-Host "`n=== COLOR SCHEMES (PRESETS.DAWN) ==="
foreach ($prop in $d.presets.Dawn.color_schemes.PSObject.Properties) {
    $s = $prop.Value.settings
    Write-Host "$($prop.Name): background=$($s.background), text=$($s.text), button=$($s.button), button_label=$($s.button_label), sec_btn=$($s.secondary_button_label), shadow=$($s.shadow)"
}
