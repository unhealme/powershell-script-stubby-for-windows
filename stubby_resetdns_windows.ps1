$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
exit $LASTEXITCODE
}
Get-NetAdapter -Physical | ForEach-Object {
   $ifname = $_.Name
   Write-Host "Resetting DNS servers on interface $ifname - the system will use default DNS service."
   set-dnsclientserveraddress $ifname -ResetServerAddresses
   $new_value = get-dnsclientserveraddress $ifname
   Write-Output -InputObjext $new_value
}
$p = Get-Process -Name "stubby"
Stop-Process -InputObject $p
Get-Process | Where-Object {$_.HasExited}