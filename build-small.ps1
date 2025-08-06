Write-Host "Building Sleep Deprivation - Framework Dependent (SMALL)" -ForegroundColor Green
Write-Host "Requires .NET 9.0 Runtime on target system" -ForegroundColor Yellow

# Clean
if (Test-Path "builds-small") { Remove-Item "builds-small" -Recurse -Force }
New-Item -ItemType Directory -Path "builds-small" | Out-Null

Write-Host "`nBuilding x64..." -ForegroundColor Cyan
dotnet publish --runtime win-x64 --configuration Release --output builds-small/windows-x64 --self-contained false --verbosity minimal

Write-Host "Building x86..." -ForegroundColor Cyan  
dotnet publish --runtime win-x86 --configuration Release --output builds-small/windows-x86 --self-contained false --verbosity minimal

Write-Host "Building ARM64..." -ForegroundColor Cyan
dotnet publish --runtime win-arm64 --configuration Release --output builds-small/windows-arm64 --self-contained false --verbosity minimal

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Framework-Dependent Build Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Show sizes
$archs = @("windows-x64", "windows-x86", "windows-arm64")
foreach ($arch in $archs) {
    $exePath = "builds-small\$arch\SleepDeprivation.exe"
    if (Test-Path $exePath) {
        $sizeKB = [math]::Round((Get-Item $exePath).Length / 1KB, 0)
        Write-Host "$($arch.PadRight(15)): $sizeKB KB" -ForegroundColor Yellow
    }
}

Write-Host "`nNOTE: Requires .NET 9.0 Runtime installed on target system!" -ForegroundColor Red