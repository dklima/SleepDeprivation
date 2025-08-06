# Sleep Deprivation - Portable Build Script
# Generates self-contained executables for all Windows architectures (~200MB each)

param(
    [string]$Configuration = "Release",
    [switch]$Clean,
    [switch]$Verbose,
    [switch]$CreateZips
)

Write-Host "=================================================" -ForegroundColor Green
Write-Host "Sleep Deprivation - Portable Build Script" -ForegroundColor Green  
Write-Host "Self-contained builds (~200MB each)" -ForegroundColor Green
Write-Host "No .NET installation required on target system!" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Green

# Define architectures
$architectures = @("win-x64", "win-x86", "win-arm64")
$projectName = "SleepDeprivation"
$outputBaseDir = "builds-portable"

# Clean previous builds if requested
if ($Clean) {
    Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Yellow
    if (Test-Path $outputBaseDir) {
        Remove-Item $outputBaseDir -Recurse -Force
        Write-Host "✅ Cleaned: $outputBaseDir" -ForegroundColor Green
    }
    
    # Clean obj and bin directories
    @(".\bin", ".\obj") | ForEach-Object {
        if (Test-Path $_) {
            Remove-Item $_ -Recurse -Force
            Write-Host "✅ Cleaned: $_" -ForegroundColor Green
        }
    }
}

# Create output directory
if (!(Test-Path $outputBaseDir)) {
    New-Item -ItemType Directory -Path $outputBaseDir -Force | Out-Null
    Write-Host "📁 Created output directory: $outputBaseDir" -ForegroundColor Cyan
}

# Restore dependencies first
Write-Host "`n🔄 Restoring dependencies..." -ForegroundColor Cyan
dotnet restore
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to restore dependencies!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dependencies restored successfully" -ForegroundColor Green

$buildResults = @()

# Build for each architecture
foreach ($arch in $architectures) {
    $friendlyName = $arch -replace "win-", "windows-"
    Write-Host "`n🏗️  Building for $arch (self-contained)..." -ForegroundColor Cyan
    
    $outputDir = Join-Path $outputBaseDir $friendlyName
    $startTime = Get-Date
    
    # Build arguments
    $buildArgs = @(
        "publish"
        "--configuration", $Configuration
        "--runtime", $arch
        "--self-contained", "true"
        "--output", $outputDir
        "/p:PublishSingleFile=true"
        "/p:IncludeNativeLibrariesForSelfExtract=true"
        "/p:PublishTrimmed=false"
    )
    
    if ($Verbose) {
        $buildArgs += "--verbosity", "normal"
    } else {
        $buildArgs += "--verbosity", "minimal"
    }
    
    # Execute build
    & dotnet $buildArgs
    
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalSeconds
    
    if ($LASTEXITCODE -eq 0) {
        # Get file size
        $exePath = Join-Path $outputDir "$projectName.exe"
        if (Test-Path $exePath) {
            $fileSize = (Get-Item $exePath).Length
            $fileSizeMB = [math]::Round($fileSize / 1MB, 1)
            
            Write-Host "✅ $friendlyName build completed successfully!" -ForegroundColor Green
            Write-Host "   📁 Output: $outputDir" -ForegroundColor Gray
            Write-Host "   📏 Size: $fileSizeMB MB" -ForegroundColor Gray
            Write-Host "   ⏱️  Time: $([math]::Round($duration, 1))s" -ForegroundColor Gray
            
            $buildResults += [PSCustomObject]@{
                Architecture = $friendlyName
                Status = "✅ Success"
                Size = "$fileSizeMB MB"
                Time = "$([math]::Round($duration, 1))s"
                Path = $outputDir
            }
            
            # Create ZIP if requested
            if ($CreateZips) {
                $zipPath = "$outputBaseDir\$projectName-$friendlyName-portable.zip"
                Write-Host "   📦 Creating ZIP: $zipPath" -ForegroundColor Gray
                Compress-Archive -Path "$outputDir\*" -DestinationPath $zipPath -Force
                $zipSizeMB = [math]::Round((Get-Item $zipPath).Length / 1MB, 1)
                Write-Host "   📦 ZIP Size: $zipSizeMB MB" -ForegroundColor Gray
            }
        } else {
            Write-Host "❌ Executable not found: $exePath" -ForegroundColor Red
            $buildResults += [PSCustomObject]@{
                Architecture = $friendlyName
                Status = "❌ Failed (No EXE)"
                Size = "N/A"
                Time = "$([math]::Round($duration, 1))s"
                Path = $outputDir
            }
        }
    } else {
        Write-Host "❌ $friendlyName build failed!" -ForegroundColor Red
        $buildResults += [PSCustomObject]@{
            Architecture = $friendlyName
            Status = "❌ Failed"
            Size = "N/A" 
            Time = "$([math]::Round($duration, 1))s"
            Path = "N/A"
        }
    }
}

# Display summary
Write-Host "`n=================================================" -ForegroundColor Green
Write-Host "BUILD SUMMARY" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

$buildResults | Format-Table -AutoSize

# Calculate total size
$totalSize = 0
$successCount = 0
foreach ($result in $buildResults) {
    if ($result.Status -like "*Success*" -and $result.Size -ne "N/A") {
        $sizeMB = [float]($result.Size -replace " MB", "")
        $totalSize += $sizeMB
        $successCount++
    }
}

if ($successCount -gt 0) {
    Write-Host "📊 Total size of all builds: $([math]::Round($totalSize, 1)) MB" -ForegroundColor Cyan
    Write-Host "📊 Average size per build: $([math]::Round($totalSize / $successCount, 1)) MB" -ForegroundColor Cyan
}

Write-Host "✅ Successful builds: $successCount/$($architectures.Count)" -ForegroundColor Green

if ($successCount -eq $architectures.Count) {
    Write-Host "`n🎉 All portable builds completed successfully!" -ForegroundColor Green
    Write-Host "📁 Find your executables in: $outputBaseDir" -ForegroundColor Cyan
    
    # Show directory structure
    Write-Host "`n📁 Directory structure:" -ForegroundColor Cyan
    Get-ChildItem $outputBaseDir -Directory | ForEach-Object {
        $exePath = Join-Path $_.FullName "$projectName.exe"
        if (Test-Path $exePath) {
            $size = [math]::Round((Get-Item $exePath).Length / 1MB, 1)
            Write-Host "   $($_.Name)\ → $projectName.exe ($size MB)" -ForegroundColor Gray
        }
    }
    
    if ($CreateZips) {
        Write-Host "`n📦 ZIP files:" -ForegroundColor Cyan
        Get-ChildItem $outputBaseDir -Filter "*.zip" | ForEach-Object {
            $size = [math]::Round($_.Length / 1MB, 1)
            Write-Host "   $($_.Name) ($size MB)" -ForegroundColor Gray
        }
    }
    
    Write-Host "`n💡 These are PORTABLE builds - no .NET installation required!" -ForegroundColor Yellow
    Write-Host "💡 Simply copy the .exe file to any Windows machine and run!" -ForegroundColor Yellow
    
    if (!$CreateZips) {
        Write-Host "💡 Use -CreateZips parameter to generate ZIP files automatically!" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n⚠️  Some builds failed. Check the output above for details." -ForegroundColor Yellow
    exit 1
}

Write-Host "`n🎯 Usage examples:" -ForegroundColor Cyan
Write-Host "   .\build-portable.ps1                    # Basic build" -ForegroundColor Gray
Write-Host "   .\build-portable.ps1 -Clean             # Clean first" -ForegroundColor Gray
Write-Host "   .\build-portable.ps1 -CreateZips        # Create ZIP files" -ForegroundColor Gray
Write-Host "   .\build-portable.ps1 -Verbose -Clean    # Verbose with clean" -ForegroundColor Gray