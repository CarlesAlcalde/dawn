 = Get-Content -Raw -Path 'config\settings_data.json'
try {
     =  | ConvertFrom-Json
    Write-Host 'JSON VALID: TRUE'
} catch {
    Write-Host 'JSON VALID: FALSE'
    Write-Host .Exception.Message
    exit 1
}

 = .current
Write-Host '--- Typography Settings ---'
.PSObject.Properties | Where-Object { .Name -like '*typography*' -or .Name -like '*font*' } | ForEach-Object {
    Write-Host  : 
}

Write-Host  
--- Color Schemes ---
.PSObject.Properties | Where-Object { .Name -like 'scheme-*' } | ForEach-Object {
    Write-Host []
    .Value.PSObject.Properties | ForEach-Object {
        Write-Host  : 
    }
}

Write-Host  
--- Checking Color Tokens Deviation ---
 = @('#121212', '#ffffff', '#121212', '#334fb4', '#e22120')
 = @()
.PSObject.Properties | Where-Object { .Name -like 'scheme-*' } | ForEach-Object {
    .Value.PSObject.Properties | ForEach-Object {
        if (.Value -match '^#[0-9a-fA-F]{3,6}$') {
             += .Value
        }
    }
}
 =  | Select-Object -Unique
Write-Host Unique Hex Colors Found: 0 
 | ForEach-Object { Write-Host  Hex:  }
