#Requires -RunAsAdministrator

<#
.SYNOPSIS
    OSDCloud deployment script with configurable parameters
.DESCRIPTION
    This script will deploy Windows using OSDCloud with easy-to-modify parameters
.PARAMETER OSVersion
    Windows version to install (e.g., "Windows 11 25H2 x64", "Windows 11 24H2 x64", "Windows 10 22H2 x64")
.PARAMETER OSEdition
    Windows edition (Pro, Home, Enterprise, Education)
.PARAMETER OSLanguage
    Language code (en-us, en-gb, de-de, fr-fr, es-es, etc.)
.PARAMETER ZeroTouch
    Enable Zero Touch Installation (no prompts)
.PARAMETER FindLocal
    Look for local ISO/WIM files on USB first before downloading
.NOTES
    Place this script on your USB or host it on GitHub
    Update the parameters section below to change deployment settings
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$OSVersion = "Windows 11 25H2 x64",
    
    [Parameter()]
    [ValidateSet('Pro','Home','Enterprise','Education')]
    [string]$OSEdition = "Pro",
    
    [Parameter()]
    [string]$OSLanguage = "en-us",
    
    [Parameter()]
    [bool]$ZeroTouch = $true,
    
    [Parameter()]
    [bool]$FindLocal = $false,
    
    [Parameter()]
    [bool]$UseLocalDrivers = $false,
    
    [Parameter()]
    [string]$DriverPath = ""
)

# ============================================
# CONFIGURATION - Edit these values as needed
# ============================================
# Uncomment and modify to override parameters:
$OSVersion = "Windows 11 24H2 x64"
$OSEdition = "Enterprise"
$OSLanguage = "en-gb"
# $ZeroTouch = $true
$FindLocal = $true
$UseLocalDrivers = $true
$DriverPath = "C:\OSDCloud\Drivers"  # Custom driver location (optional)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  OSDCloud Deployment Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "OS Version:      $OSVersion" -ForegroundColor Yellow
Write-Host "Edition:         $OSEdition" -ForegroundColor Yellow
Write-Host "Language:        $OSLanguage" -ForegroundColor Yellow
Write-Host "Zero Touch:      $ZeroTouch" -ForegroundColor Yellow
Write-Host "Find Local OS:   $FindLocal" -ForegroundColor Yellow
Write-Host "Local Drivers:   $UseLocalDrivers" -ForegroundColor Yellow
if ($DriverPath) {
    Write-Host "Driver Path:     $DriverPath" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "Starting deployment..." -ForegroundColor Green
Write-Host ""

# Build Start-OSDCloud parameters
$OSDCloudParams = @{
    OSName     = $OSVersion
    OSEdition  = $OSEdition
    OSLanguage = $OSLanguage
}

# Add optional parameters
if ($ZeroTouch) {
    $OSDCloudParams.Add('ZTI', $true)
}

if ($FindLocal) {
    $OSDCloudParams.Add('FindImageFile', $true)
}

# Handle driver configuration
if ($UseLocalDrivers) {
    Write-Host "Configuring local drivers..." -ForegroundColor Cyan
    
    if ($DriverPath -and (Test-Path $DriverPath)) {
        # Use custom driver path
        Write-Host "Using drivers from: $DriverPath" -ForegroundColor Green
        $OSDCloudParams.Add('DriverPath', $DriverPath)
    } else {
        # Search default locations
        $DefaultDriverPaths = @(
            "$env:SystemDrive\OSDCloud\Drivers",
            "$env:SystemDrive\Drivers",
            "X:\OSDCloud\Drivers"  # WinPE drive
        )
        
        foreach ($Path in $DefaultDriverPaths) {
            if (Test-Path $Path) {
                Write-Host "Found drivers at: $Path" -ForegroundColor Green
                $OSDCloudParams.Add('DriverPath', $Path)
                break
            }
        }
        
        if (-not $OSDCloudParams.ContainsKey('DriverPath')) {
            Write-Host "No local drivers found. Will use cloud drivers if available." -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "Using cloud-based driver detection..." -ForegroundColor Cyan
}

# Start OSDCloud deployment
Start-OSDCloud @OSDCloudParams

Write-Host ""
Write-Host "Deployment process initiated..." -ForegroundColor Green
Write-Host ""
