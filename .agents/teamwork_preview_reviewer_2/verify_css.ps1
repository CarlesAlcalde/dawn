$css = Get-Content 'assets/velnordesk.css' -Raw

$openBraces = ([regex]::Matches($css, '\{')).Count
$closeBraces = ([regex]::Matches($css, '\}')).Count

Write-Host "Open braces: $openBraces, Close braces: $closeBraces"
if ($openBraces -ne $closeBraces) {
    Write-Error "Mismatched braces in velnordesk.css!"
} else {
    Write-Host "Brace balance check passed!"
}

# Check for undefined CSS variables or broken syntax patterns
$brokenTokens = [regex]::Matches($css, 'var\(--[a-zA-Z0-9_-]+\)') | ForEach-Object { $_.Value } | Sort-Object -Unique
Write-Host "Referenced CSS variables count: $($brokenTokens.Count)"
