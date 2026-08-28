try {
     = [System.IO.File]::ReadAllText('c:\Users\Spanish OCTO 1\Desktop\CarlesAlcalde\config\settings_data.json')
     = [System.Text.RegularExpressions.Regex]::Replace(, '/\*[\s\S]*?\*/', '')
     = ConvertFrom-Json -InputObject  -ErrorAction Stop
    Write-Output '=== VALIDATION SUCCESS ==='
    Write-Output ('Current Header Font: ' + .current.type_header_font)
    Write-Output ('Current Body Font: ' + .current.type_body_font)
    Write-Output ('Current Heading Scale: ' + .current.heading_scale)
    Write-Output ('Current Body Scale: ' + .current.body_scale)
    Write-Output ('--- Color Schemes (Current) ---')
    Write-Output ('Scheme 1 Background: ' + .current.color_schemes.'scheme-1'.settings.background + ' | Button: ' + .current.color_schemes.'scheme-1'.settings.button + ' | Text: ' + .current.color_schemes.'scheme-1'.settings.text + ' | Button Label: ' + .current.color_schemes.'scheme-1'.settings.button_label + ' | Sec Button: ' + .current.color_schemes.'scheme-1'.settings.secondary_button_label + ' | Shadow: ' + .current.color_schemes.'scheme-1'.settings.shadow)
    Write-Output ('Scheme 2 Background: ' + .current.color_schemes.'scheme-2'.settings.background + ' | Button: ' + .current.color_schemes.'scheme-2'.settings.button + ' | Text: ' + .current.color_schemes.'scheme-2'.settings.text + ' | Button Label: ' + .current.color_schemes.'scheme-2'.settings.button_label + ' | Sec Button: ' + .current.color_schemes.'scheme-2'.settings.secondary_button_label + ' | Shadow: ' + .current.color_schemes.'scheme-2'.settings.shadow)
    Write-Output ('Scheme 3 Background: ' + .current.color_schemes.'scheme-3'.settings.background + ' | Button: ' + .current.color_schemes.'scheme-3'.settings.button + ' | Text: ' + .current.color_schemes.'scheme-3'.settings.text + ' | Button Label: ' + .current.color_schemes.'scheme-3'.settings.button_label + ' | Sec Button: ' + .current.color_schemes.'scheme-3'.settings.secondary_button_label + ' | Shadow: ' + .current.color_schemes.'scheme-3'.settings.shadow)
    Write-Output ('Scheme 4 Background: ' + .current.color_schemes.'scheme-4'.settings.background + ' | Button: ' + .current.color_schemes.'scheme-4'.settings.button + ' | Text: ' + .current.color_schemes.'scheme-4'.settings.text + ' | Button Label: ' + .current.color_schemes.'scheme-4'.settings.button_label + ' | Sec Button: ' + .current.color_schemes.'scheme-4'.settings.secondary_button_label + ' | Shadow: ' + .current.color_schemes.'scheme-4'.settings.shadow)
    Write-Output ('Scheme 5 Background: ' + .current.color_schemes.'scheme-5'.settings.background + ' | Button: ' + .current.color_schemes.'scheme-5'.settings.button + ' | Text: ' + .current.color_schemes.'scheme-5'.settings.text + ' | Button Label: ' + .current.color_schemes.'scheme-5'.settings.button_label + ' | Sec Button: ' + .current.color_schemes.'scheme-5'.settings.secondary_button_label + ' | Shadow: ' + .current.color_schemes.'scheme-5'.settings.shadow)
} catch {
    Write-Error .Exception.Message
    exit 1
}
