# Sleep Deprivation - Build Guide

## Multi-Architecture Build Support

This project supports building executables for different Windows architectures:

- **x64** (Intel/AMD 64-bit) - Standard for modern desktops
- **x86** (Intel/AMD 32-bit) - Compatibility with legacy systems  
- **ARM64** - Windows on ARM processors (Surface Pro X, etc.)

## Requirements

- .NET 9.0 SDK
- Windows (for testing executables)
- PowerShell (for automated scripts)

## Automated Builds

### Option 1: PowerShell Scripts (Recommended)

#### Small Build - Framework Dependent (~150KB)
```powershell
.\build-small.ps1
```

#### Portable Build - Self Contained (~150MB)
```powershell
.\build-portable.ps1
```

### Option 2: Batch Script
```cmd
build-all-architectures.bat
```

All scripts create build folders with architecture-specific subfolders:
```
builds-small/          # Framework-dependent builds
├── windows-x64/
├── windows-x86/
└── windows-arm64/

builds-portable/       # Self-contained builds  
├── windows-x64/
├── windows-x86/
└── windows-arm64/
```

## Manual Builds

### Framework-Dependent (Small)

#### x64 (64-bit Intel/AMD)
```bash
dotnet publish --runtime win-x64 --configuration Release --output builds-small/windows-x64 --self-contained false
```

#### x86 (32-bit Intel/AMD) 
```bash
dotnet publish --runtime win-x86 --configuration Release --output builds-small/windows-x86 --self-contained false
```

#### ARM64 (Windows on ARM)
```bash
dotnet publish --runtime win-arm64 --configuration Release --output builds-small/windows-arm64 --self-contained false
```

### Self-Contained (Portable)

#### x64 (64-bit Intel/AMD)
```bash
dotnet publish --runtime win-x64 --configuration Release --output builds-portable/windows-x64 --self-contained true
```

#### x86 (32-bit Intel/AMD)
```bash
dotnet publish --runtime win-x86 --configuration Release --output builds-portable/windows-x86 --self-contained true
```

#### ARM64 (Windows on ARM)
```bash
dotnet publish --runtime win-arm64 --configuration Release --output builds-portable/windows-arm64 --self-contained true
```

## Build Types Comparison

### Framework-Dependent (Recommended)
- **Size**: ~150KB
- **Pros**:
  - ✅ Ultra-small size
  - ✅ Automatic .NET security updates
  - ✅ Better performance and compatibility
  - ✅ Easy distribution
- **Cons**:
  - ⚠️ Requires .NET 9.0 Runtime on target system

### Self-Contained (Portable)
- **Size**: ~150MB
- **Pros**:
  - ✅ Works without any installation
  - ✅ Portable, runs on any Windows system
- **Cons**:
  - ❌ Large file size
  - ❌ Slower to download/distribute
  - ❌ No automatic security updates

## Distribution Recommendations

### For Most Users: Framework-Dependent
- **99.9% smaller** than self-contained
- User installs .NET 9.0 once (~50MB download)
- Much smaller total footprint than 150MB per app

### .NET 9.0 Runtime Installation
```
https://dotnet.microsoft.com/download/dotnet/9.0/runtime
```
Choose: ".NET Desktop Runtime 9.0.x"

### For Special Cases: Self-Contained
- Users who cannot install .NET Runtime
- Airgapped/isolated environments
- Single-use deployments

## Typical Build Sizes

- **Framework-Dependent x64**: ~152 KB
- **Framework-Dependent x86**: ~123 KB
- **Framework-Dependent ARM64**: ~150 KB
- **Self-Contained x64**: ~163 MB
- **Self-Contained x86**: ~152 MB
- **Self-Contained ARM64**: ~176 MB

## Distribution Guide

### Framework-Dependent Distribution
1. Run `.\build-small.ps1`
2. Distribute entire `builds-small/windows-x64/` folder
3. User installs .NET 9.0 Runtime if needed
4. User runs `SleepDeprivation.exe`

### Self-Contained Distribution
1. Run `.\build-portable.ps1`
2. Distribute entire `builds-portable/windows-x64/` folder  
3. User runs `SleepDeprivation.exe` directly

## Architecture Selection Guide

- **Most modern PCs**: `windows-x64`
- **Legacy/32-bit systems**: `windows-x86`
- **Surface Pro X & ARM devices**: `windows-arm64`

## Technical Notes

- Uses .NET 9.0 with Windows-specific features (WPF)
- Configured for single-file publishing when self-contained
- Includes native libraries for system tray integration
- Optimized for minimal footprint and maximum compatibility