# Sleep Deprivation - Large Portable Build Script
# Generates self-contained executables (~200MB each)

Write-Host "=================================================" -ForegroundColor Green
Write-Host "Sleep Deprivation - Large Portable Builds" -ForegroundColor Green  
Write-Host "Self-contained builds (~200MB each)" -ForegroundColor Green
Write-Host "No .NET installation required!" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Green

# Clean previous builds
Write-Host "`n🧹 Cleaning previous builds..." -ForegroundColor Yellow
if (Test-Path "build-portable") { 
    Remove-Item "build-portable" -Recurse -Force 
    Write-Host "✅ Cleaned build-portable directory" -ForegroundColor Green
}
New-Item -ItemType Directory -Path "build-portable" -Force | Out-Null

# Restore dependencies
Write-Host "`n🔄 Restoring dependencies..." -ForegroundColor Cyan
dotnet restore
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to restore dependencies!" -ForegroundColor Red
    exit 1
}

# Build for each architecture
$architectures = @(
    @{Name="win-x64"; Display="Windows x64"},
    @{Name="win-x86"; Display="Windows x86"},
    @{Name="win-arm64"; Display="Windows ARM64"}
)

$results = @()

foreach ($arch in $architectures) {
    $archName = $arch.Name
    $displayName = $arch.Display
    $outputDir = "build-portable\$($archName -replace 'win-', 'windows-')"
    
    Write-Host "`n🏗️  Building $displayName..." -ForegroundColor Cyan
    $startTime = Get-Date
    
    dotnet publish `
        --runtime $archName `
        --configuration Release `
        --output $outputDir `
        --self-contained true `
        --verbosity minimal `
        /p:PublishSingleFile=true `
        /p:IncludeNativeLibrariesForSelfExtract=true
    
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalSeconds
    
    if ($LASTEXITCODE -eq 0) {
        $exePath = "$outputDir\SleepDeprivation.exe"
        if (Test-Path $exePath) {
            $sizeMB = [math]::Round((Get-Item $exePath).Length / 1MB, 1)
            
            Write-Host "✅ $displayName build completed!" -ForegroundColor Green
            Write-Host "   📏 Size: $sizeMB MB" -ForegroundColor Gray
            Write-Host "   ⏱️  Time: $([math]::Round($duration, 1))s" -ForegroundColor Gray
            
            $results += [PSCustomObject]@{
                Architecture = $displayName
                Status = "✅ Success"
                Size = "$sizeMB MB"
                Time = "$([math]::Round($duration, 1))s"
                Path = $outputDir
            }
            
            # Create ZIP
            $zipPath = "build-portable\SleepDeprivation-$($archName)-portable.zip"
            Write-Host "   📦 Creating ZIP..." -ForegroundColor Gray
            Compress-Archive -Path "$outputDir\*" -DestinationPath $zipPath -Force
            $zipSizeMB = [math]::Round((Get-Item $zipPath).Length / 1MB, 1)
            Write-Host "   📦 ZIP: $zipSizeMB MB" -ForegroundColor Gray
        } else {
            Write-Host "❌ Executable not found!" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Build failed!" -ForegroundColor Red
        $results += [PSCustomObject]@{
            Architecture = $displayName
            Status = "❌ Failed"
            Size = "N/A"
            Time = "$([math]::Round($duration, 1))s"
            Path = "N/A"
        }
    }
}

# Show summary
Write-Host "`n=================================================" -ForegroundColor Green
Write-Host "BUILD SUMMARY" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

$results | Format-Table -AutoSize

# Calculate totals
$successful = $results | Where-Object { $_.Status -like "*Success*" }
$totalSize = ($successful | ForEach-Object { [float]($_.Size -replace " MB", "") }) | Measure-Object -Sum | Select-Object -ExpandProperty Sum

Write-Host "✅ Successful builds: $($successful.Count)/$($architectures.Count)" -ForegroundColor Green
if ($successful.Count -gt 0) {
    Write-Host "📊 Total size: $([math]::Round($totalSize, 1)) MB" -ForegroundColor Cyan
    Write-Host "📊 Average size: $([math]::Round($totalSize / $successful.Count, 1)) MB" -ForegroundColor Cyan
}

if ($successful.Count -eq $architectures.Count) {
    Write-Host "`n🎉 All builds completed successfully!" -ForegroundColor Green
    
    # Show directory structure
    Write-Host "`n📁 Generated files:" -ForegroundColor Cyan
    Get-ChildItem "build-portable" -Recurse -File -Filter "*.exe" | ForEach-Object {
        $sizeMB = [math]::Round($_.Length / 1MB, 1)
        Write-Host "   $($_.FullName) ($sizeMB MB)" -ForegroundColor Gray
    }
    
    Write-Host "`n📦 ZIP packages:" -ForegroundColor Cyan
    Get-ChildItem "build-portable" -Filter "*.zip" | ForEach-Object {
        $sizeMB = [math]::Round($_.Length / 1MB, 1)
        Write-Host "   $($_.Name) ($sizeMB MB)" -ForegroundColor Gray
    }
    
    Write-Host "`n💡 These are PORTABLE executables!" -ForegroundColor Yellow
    Write-Host "💡 No .NET installation required on target system!" -ForegroundColor Yellow
    Write-Host "💡 Simply copy and run on any Windows machine!" -ForegroundColor Yellow
} else {
    Write-Host "`n⚠️  Some builds failed." -ForegroundColor Yellow
}