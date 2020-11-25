$stubproc=Get-Process stubby -ErrorAction SilentlyContinue
if ( $stubproc -ne $null ) {
	Write-Host "Stubby is running"
}
elseif ( $stubproc -eq $null ) {
	Write-Host "Stubby is not running"
}
Write-Host
Get-NetAdapter -Physical | ForEach-Object {
   $ifname = $_.Name
   $new_value = get-dnsclientserveraddress $ifname
   Write-Host "Active DNS server address"
   Write-Host "========================="
   Write-Output -InputObject $new_value
}
Pause