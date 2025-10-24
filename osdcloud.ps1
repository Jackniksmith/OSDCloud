# --- OSDCloud Deployment Parameters ---

Write-Output "Testing CloudOS Deployment 1.0"

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# OS configuration
$OSName       = 'Windows 11 25H2 x64'
$OSEdition    = 'Pro'
$OSActivation = 'Retail'
$OSLanguage   = 'en-us'

# Paths for local repositories
$LocalOSPath      = "C:\OSDCloud\OS\Windows11_25H2"      # Path to extracted OS (install.wim/install.esd)
$LocalDriversPath = "C:\OSDCloud\Drivers"                     # Root folder containing model-specific driver folders
$LocalUpdatesPath = "C:\OSDCloud\Updates\Windows11_25H2"     # Folder containing CAB/MSU updates (optional)

# --- OSDCloud Options ---
$Global:MyOSDCloud = [ordered]@{
    Restart                 = $false
    RecoveryPartition       = $true
    OEMActivation           = $true
    WindowsUpdate           = $true   # Fallback online updates if no local updates
    WindowsUpdateDrivers    = $true   # Fallback online drivers if no local drivers
    WindowsDefenderUpdate   = $true
    ClearDiskConfirm        = $false
    ShutdownSetupComplete   = $false
    SyncMSUpCatDriverUSB    = $true
    CheckSHA1               = $true
}

# --- Driver detection ---
$ComputerSystem = Get-CimInstance Win32_ComputerSystemProduct
#$Model = $ComputerSystem.Model.Replace(" ", "_")   # Model folder names should match this
$Model = $ComputerSystem.Version

Write-Output "Detected $Model"
write-output "$model"

$DriverParam = @{}
$ModelDriverPath = Join-Path $LocalDriversPath $Model
$ModelDriverPath
if (Test-Path $ModelDriverPath) {
    Write-Host "Local drivers found for $Model at $ModelDriverPath" -ForegroundColor Cyan
    $DriverParam = @{ LocalDrivers = $ModelDriverPath }
} else {
    Write-Host "No local drivers found for $Model. Will use online drivers." -ForegroundColor Yellow
}

# --- Local updates detection ---
$UpdateParam = @{}
if (Test-Path $LocalUpdatesPath) {
    Write-Host "Local updates found at $LocalUpdatesPath" -ForegroundColor Cyan
    $UpdateParam = @{ LocalUpdates = $LocalUpdatesPath }
} else {
    Write-Host "No local updates found. Will use online updates." -ForegroundColor Yellow
}

# --- Start OSDCloud Deployment ---
$OSParams = @{
    OSName       = $OSName
    OSEdition    = $OSEdition
    OSActivation = $OSActivation
    OSLanguage   = $OSLanguage
}

# Add local OS if path exists
if (Test-Path $LocalOSPath) {
    $OSParams.Add('LocalOS', $true)
    $OSParams.Add('LocalPath', $LocalOSPath)
}

# Merge driver and update parameters
$OSParams = $OSParams + $DriverParam + $UpdateParam

# Launch deployment
Write-Host "Starting OSDCloud deployment..." -ForegroundColor Green
Start-OSDCloud @OSParams
