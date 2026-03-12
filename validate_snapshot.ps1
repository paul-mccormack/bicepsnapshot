$snapshot_result = bicep snapshot main.bicepparam --mode validate --subscription-id 8a9d9b4d-56c8-4fe7-b760-6b84698a3353 --location uksouth

if ($snapshot_result -eq $null) {
    Write-Host "`n"
    Write-Host "No changes detected in the snapshot."
    Write-Host "`n"
    $snapshot_result = "No changes detected in the snapshot."
} else {
    Write-Host "`n"
    Write-Host "Changes detected in the snapshot:"
    Write-Host "`n"
    Write-Host $snapshot_result
}