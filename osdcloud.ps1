write-output "OSDCloud Imager"

$version = "24h2"
$wipedisk = $true
$os = "11"
$OSEdition = "Pro"
$cleardiskconfirm = "-noprompt"

sleep 20
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Start-OSDCloud -OSName 'Windows 11 24h2 x64' -OSLanguage en-us -OSEdition Pro -OSActivation Retail -zti -wipedisk $cleardisk

sleep 20
