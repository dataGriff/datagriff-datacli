# DataGriff DataCLI Windows Installation Script
# This script downloads and installs datagriff-datacli for Windows

param(
    [string]$Version = "latest",
    [string]$InstallPath = "$env:LOCALAPPDATA\datagriff-datacli",
    [switch]$AddToPath = $true,
    [switch]$Force = $false
)

# Configuration
$RepoOwner = "dataGriff"
$RepoName = "learn-go-cli-cobra"
$BinaryName = "datagriff-datacli"

# Determine architecture
$Architecture = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }
if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { $Architecture = "arm64" }

Write-Host "🚀 DataGriff DataCLI Windows Installer" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Function to get latest release info
function Get-LatestRelease {
    try {
        $apiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/releases/latest"
        Write-Host "📡 Checking for latest release..." -ForegroundColor Yellow
        $release = Invoke-RestMethod -Uri $apiUrl -Headers @{"User-Agent" = "datagriff-datacli-installer"}
        return $release
    }
    catch {
        Write-Error "❌ Failed to fetch release information: $_"
        exit 1
    }
}

# Function to download file
function Download-File {
    param($Url, $OutputPath)
    
    try {
        Write-Host "⬇️  Downloading from: $Url" -ForegroundColor Yellow
        
        # Create directory if it doesn't exist
        $dir = Split-Path $OutputPath -Parent
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        
        # Download with progress
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($Url, $OutputPath)
        
        Write-Host "✅ Downloaded successfully!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "❌ Download failed: $_"
        return $false
    }
}

# Function to extract zip file
function Extract-Archive {
    param($ZipPath, $ExtractPath)
    
    try {
        Write-Host "📦 Extracting archive..." -ForegroundColor Yellow
        
        # Remove existing installation if Force is specified
        if ($Force -and (Test-Path $ExtractPath)) {
            Remove-Item $ExtractPath -Recurse -Force
        }
        
        # Create extraction directory
        if (!(Test-Path $ExtractPath)) {
            New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null
        }
        
        # Extract using .NET
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipPath, $ExtractPath)
        
        Write-Host "✅ Extraction completed!" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "❌ Extraction failed: $_"
        return $false
    }
}

# Function to add to PATH
function Add-ToPath {
    param($PathToAdd)
    
    try {
        Write-Host "🔧 Adding to PATH..." -ForegroundColor Yellow
        
        # Get current user PATH
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        
        # Check if already in PATH
        if ($currentPath -split ";" -contains $PathToAdd) {
            Write-Host "✅ Already in PATH!" -ForegroundColor Green
            return
        }
        
        # Add to PATH
        $newPath = if ($currentPath) { "$currentPath;$PathToAdd" } else { $PathToAdd }
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        
        # Update current session PATH
        $env:PATH = "$env:PATH;$PathToAdd"
        
        Write-Host "✅ Added to PATH successfully!" -ForegroundColor Green
        Write-Host "   You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
    }
    catch {
        Write-Error "❌ Failed to add to PATH: $_"
        Write-Host "   You can manually add '$PathToAdd' to your PATH." -ForegroundColor Yellow
    }
}

# Main installation logic
try {
    # Get release information
    if ($Version -eq "latest") {
        $release = Get-LatestRelease
        $Version = $release.tag_name
    }
    
    Write-Host "📋 Installation Details:" -ForegroundColor Cyan
    Write-Host "   Version: $Version" -ForegroundColor White
    Write-Host "   Architecture: $Architecture" -ForegroundColor White
    Write-Host "   Install Path: $InstallPath" -ForegroundColor White
    Write-Host ""
    
    # Construct download URL
    $fileName = "datagriff-datacli-windows-$Architecture.zip"
    $downloadUrl = "https://github.com/$RepoOwner/$RepoName/releases/download/$Version/$fileName"
    $zipPath = "$env:TEMP\$fileName"
    
    # Check if already installed
    $binaryPath = "$InstallPath\$BinaryName.exe"
    if ((Test-Path $binaryPath) -and !$Force) {
        Write-Host "⚠️  DataGriff DataCLI is already installed at: $binaryPath" -ForegroundColor Yellow
        Write-Host "   Use -Force to reinstall" -ForegroundColor Yellow
        
        # Test existing installation
        $currentVersion = & $binaryPath --help 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Existing installation is working!" -ForegroundColor Green
            exit 0
        }
    }
    
    # Download the release
    if (!(Download-File -Url $downloadUrl -OutputPath $zipPath)) {
        exit 1
    }
    
    # Extract the archive
    if (!(Extract-Archive -ZipPath $zipPath -ExtractPath $InstallPath)) {
        exit 1
    }
    
    # Verify installation
    if (Test-Path $binaryPath) {
        Write-Host "✅ Installation completed successfully!" -ForegroundColor Green
        
        # Test the binary
        try {
            $testOutput = & $binaryPath --help 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Binary is working correctly!" -ForegroundColor Green
            }
        }
        catch {
            Write-Warning "⚠️  Binary installed but may not be working correctly"
        }
        
        # Add to PATH if requested
        if ($AddToPath) {
            Add-ToPath -PathToAdd $InstallPath
        }
        
        Write-Host ""
        Write-Host "🎉 DataGriff DataCLI installation complete!" -ForegroundColor Green
        Write-Host "================================================" -ForegroundColor Cyan
        Write-Host "📍 Binary location: $binaryPath" -ForegroundColor White
        Write-Host "🚀 Try it out: datagriff-datacli list" -ForegroundColor White
        Write-Host "📚 Help: datagriff-datacli --help" -ForegroundColor White
        
    } else {
        Write-Error "❌ Installation failed - binary not found after extraction"
        exit 1
    }
    
    # Cleanup
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }
}
catch {
    Write-Error "❌ Installation failed: $_"
    exit 1
}

Write-Host ""
Write-Host "Thank you for using DataGriff DataCLI! 🎯" -ForegroundColor Cyan
