Write-Output "OSDCloud Imager"

# ======= Parameters =======
<#
$OSVersion      = "24H2"                   # Windows version
$OSName         = "11"                     # Major OS version
$OSEdition      = "Pro"                    # Edition
$OSLanguage     = "en-us"                  # Language
$OSActivation   = "Retail"                 # Activation type
$ZTI            = $true                     # Zero Touch Installation switch
$WipeDisk       = $true                     # Should the disk be wiped
$NoPrompt       = $true                     # Suppress all prompts

# ======= Initialization =======
Start-Sleep -Seconds 10

# ======= Build Start-OSDCloud Parameters Dynamically =======
$params = @{
    OSName        = "Windows $OSVersion x64"
    OSLanguage    = $OSLanguage
    OSEdition     = $OSEdition
    OSActivation  = $OSActivation
}

if ($ZTI)        { $params.ZTI       = $true }
if ($WipeDisk)   { $params.WipeDisk  = $true }
if ($NoPrompt)   { $params.NoPrompt  = $true }

# ======= Run OSDCloud =======
Start-OSDCloud @params
#>

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

#Variables to define the Windows OS / Edition etc to be applied during OSDCloud
$OSName = 'Windows 11 24H2 x64'
$OSEdition = 'Pro'
$OSActivation = 'Retail'
$OSLanguage = 'en-us'

#Set OSDCloud Vars
$Global:MyOSDCloud = [ordered]@{
    Restart = [bool]$False
    RecoveryPartition = [bool]$true
    OEMActivation = [bool]$True
    WindowsUpdate = [bool]$true
    WindowsUpdateDrivers = [bool]$true
    WindowsDefenderUpdate = [bool]$true
    SetTimeZone = [bool]$true
    ClearDiskConfirm = [bool]$False
    ShutdownSetupComplete = [bool]$false
    SyncMSUpCatDriverUSB = [bool]$true
    CheckSHA1 = [bool]$true
}

#Launch OSDCloud
Write-Host "Starting OSDCloud" -ForegroundColor Green
write-host "Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage"

Start-OSDCloud -OSName $OSName -OSEdition $OSEdition -OSActivation $OSActivation -OSLanguage $OSLanguage
