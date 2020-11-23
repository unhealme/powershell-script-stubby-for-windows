$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
exit $LASTEXITCODE
}

$stubproc=Get-Process stubby -ErrorAction SilentlyContinue
if ( $stubproc -ne $null ) {
	Stop-Process -name stubby
	Start-Process -FilePath "C:\Program Files\Stubby\stubby.exe" -WindowStyle Hidden
}
elseif ( $stubproc -eq $null ) {
	Start-Process -FilePath "C:\Program Files\Stubby\stubby.exe" -WindowStyle Hidden
}

Get-NetAdapter -Physical | ForEach-Object {
   $ifname = $_.Name
   Write-Host "Setting DNS servers on interface $ifname to use local resolver - the system will use Stubby if it is running"
   set-dnsclientserveraddress $ifname -ServerAddresses ("127.0.0.1","0::1")
   $new_value = get-dnsclientserveraddress $ifname
   Write-Output -InputObjext $new_value
}