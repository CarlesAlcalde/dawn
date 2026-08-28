$content = [System.IO.File]::ReadAllText('c:\Users\Spanish OCTO 1\Desktop\CarlesAlcalde\config\settings_data.json')
$jsonString = $content.Substring($content.IndexOf('{'))
$parsed = ConvertFrom-Json -InputObject $jsonString -ErrorAction Stop
Write-Output "=== VALIDATION SUCCESS ==="
Write-Output ("Current Header Font: " + $parsed.current.type_header_font)
Write-Output ("Current Body Font: " + $parsed.current.type_body_font)
Write-Output ("Current Heading Scale: " + $parsed.current.heading_scale)
Write-Output ("Current Body Scale: " + $parsed.current.body_scale)
Write-Output "--- Color Schemes (Current) ---"
$parsed.current.color_schemes.PSObject.Properties | ForEach-Object { $s=$_.Value.settings; Write-Output "$($_.Name): bg=$($s.background), text=$($s.text), btn=$($s.button), btn_lbl=$($s.button_label), sec_btn=$($s.secondary_button_label), shadow=$($s.shadow)" }
Write-Output "--- Color Schemes (Presets.Dawn) ---"
$parsed.presets.Dawn.color_schemes.PSObject.Properties | ForEach-Object { $s=$_.Value.settings; Write-Output "$($_.Name): bg=$($s.background), text=$($s.text), btn=$($s.button), btn_lbl=$($s.button_label), sec_btn=$($s.secondary_button_label), shadow=$($s.shadow)" }