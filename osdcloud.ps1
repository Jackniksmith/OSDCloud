write-output "testing testing 123"

sleep 20
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Start-OSDCloud -OSName 'Windows 11 24h2 x64' -OSLanguage en-us -OSEdition Pro -OSActivation Retail -zti

sleep 20
