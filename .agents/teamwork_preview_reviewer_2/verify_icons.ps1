$icons = @(
    'icon-cart.svg',
    'icon-cart-empty.svg',
    'icon-search.svg',
    'icon-account.svg',
    'icon-arrow.svg',
    'icon-lightning-bolt.svg',
    'icon-lock.svg',
    'icon-checkmark.svg'
)

foreach ($f in $icons) {
    $filePath = Join-Path 'assets' $f
    $content = Get-Content $filePath -Raw
    Write-Host "================ $f ================"
    Write-Host $content
    Write-Host ""

    # XML validation
    try {
        [xml]$xml = $content
        $viewBox = $xml.svg.viewBox
        $class = $xml.svg.class
        $fill = $xml.svg.fill
        Write-Host "XML VALID: True | viewBox: '$viewBox' | class: '$class' | fill: '$fill'"
    } catch {
        Write-Host "XML INVALID: $($_.Exception.Message)"
    }
    Write-Host ""
}
