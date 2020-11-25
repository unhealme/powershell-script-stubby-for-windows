$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
exit $LASTEXITCODE
}

Get-NetAdapter -Physical | ForEach-Object {
   $ifname = $_.Name
   set-dnsclientserveraddress $ifname -ResetServerAddresses
   $new_value = get-dnsclientserveraddress $ifname
}

Stop-Process -name stubby