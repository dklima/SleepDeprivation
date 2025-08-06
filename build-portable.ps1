Write-Host "Building Sleep Deprivation - Self Contained (PORTABLE)" -ForegroundColor Green
Write-Host "No .NET installation required, but larger size" -ForegroundColor Yellow

# Clean
if (Test-Path "builds-portable") { Remove-Item "builds-portable" -Recurse -Force }
New-Item -ItemType Directory -Path "builds-portable" | Out-Null

Write-Host "`nBuilding x64..." -ForegroundColor Cyan
dotnet publish --runtime win-x64 --configuration Release --output builds-portable/windows-x64 --self-contained true --verbosity minimal

Write-Host "Building x86..." -ForegroundColor Cyan  
dotnet publish --runtime win-x86 --configuration Release --output builds-portable/windows-x86 --self-contained true --verbosity minimal

Write-Host "Building ARM64..." -ForegroundColor Cyan
dotnet publish --runtime win-arm64 --configuration Release --output builds-portable/windows-arm64 --self-contained true --verbosity minimal

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Self-Contained Build Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Show sizes
$archs = @("windows-x64", "windows-x86", "windows-arm64")
foreach ($arch in $archs) {
    $exePath = "builds-portable\$arch\SleepDeprivation.exe"
    if (Test-Path $exePath) {
        $sizeMB = [math]::Round((Get-Item $exePath).Length / 1MB, 1)
        Write-Host "$($arch.PadRight(15)): $sizeMB MB" -ForegroundColor Yellow
    }
}

Write-Host "`nNOTE: Works without .NET installation on target system!" -ForegroundColor Green