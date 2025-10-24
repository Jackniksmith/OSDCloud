Write-Output "OSDCloud Imager"

# ======= Parameters =======
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
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

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
