Get-ChildItem -Path templates -Filter "*.json" | ForEach-Object {
    $raw = [System.IO.File]::ReadAllText($_.FullName)
    $idx = $raw.IndexOf('{')
    if ($idx -ge 0) {
        $jsonStr = $raw.Substring($idx)
        try {
            $parsed = ConvertFrom-Json $jsonStr -ErrorAction Stop
            Write-Host "$($_.Name): VALID JSON (sections count: $($parsed.sections.PSObject.Properties.Count))"
        } catch {
            Write-Host "$($_.Name): PARSE ERROR - $($_.Exception.Message)"
        }
    } else {
        Write-Host "$($_.Name): NO JSON OBJECT FOUND"
    }
}
