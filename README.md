# Sleep Deprivation

**A lightweight Windows application that prevents your computer from going to sleep or turning off the display.**

[![.NET](https://img.shields.io/badge/.NET-9.0-blue.svg)](https://dotnet.microsoft.com/)
[![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Release](https://img.shields.io/badge/release-v1.0.0-brightgreen.svg)](https://github.com/dklima/SleepDeprivation/releases)

[![Build and Test](https://github.com/dklima/SleepDeprivation/actions/workflows/build.yml/badge.svg)](https://github.com/dklima/SleepDeprivation/actions/workflows/build.yml)
[![Security](https://github.com/dklima/SleepDeprivation/actions/workflows/security.yml/badge.svg)](https://github.com/dklima/SleepDeprivation/actions/workflows/security.yml)
[![Release](https://github.com/dklima/SleepDeprivation/actions/workflows/release.yml/badge.svg)](https://github.com/dklima/SleepDeprivation/actions/workflows/release.yml)
[![Publish Packages](https://github.com/dklima/SleepDeprivation/actions/workflows/packages.yml/badge.svg)](https://github.com/dklima/SleepDeprivation/actions/workflows/packages.yml)
[![Packages](https://img.shields.io/badge/packages-nightly%20builds-orange)](https://github.com/dklima/SleepDeprivation/packages)

## ✨ Features

- 🎯 **Prevents sleep mode** - Keeps your computer awake when activated
- 🖥️ **Display control** - Prevents monitor from turning off
- 🔄 **Easy toggle** - Quick enable/disable with one click
- 📱 **System tray integration** - Runs quietly in the background
- 🎨 **Visual indicators** - Color-coded tray icons (🟢 Active / 🔴 Inactive)
- ⚡ **Lightweight** - Only ~150KB in size
- 🔧 **No installation required** - Portable executable
- 🏗️ **Multi-architecture** - Supports x64, x86, and ARM64

## 🚀 Quick Start

### 📥 Download Options

**Stable Releases**: [GitHub Releases](https://github.com/dklima/SleepDeprivation/releases) - Recommended for regular use  
**Development Builds**: [GitHub Packages](https://github.com/dklima/SleepDeprivation/packages) - Latest features and fixes  
**Nightly Builds**: Automatic builds from latest commits (found in Packages)

### Option 1: Framework-Dependent (Recommended - Super Small)

1. Download the latest release from [Releases](https://github.com/dklima/SleepDeprivation/releases)
2. Ensure you have [.NET 9.0 Runtime](https://dotnet.microsoft.com/download/dotnet/9.0/runtime) installed
3. Extract and run `SleepDeprivation.exe`
4. **Size**: ~150KB

### Option 2: Self-Contained (Portable)

1. Download the self-contained version from [Releases](https://github.com/dklima/SleepDeprivation/releases)
2. Extract and run `SleepDeprivation.exe` - no installation required
3. **Size**: ~150MB

### Option 3: Development/Nightly Builds

For the latest features and bug fixes:

1. Visit [Packages](https://github.com/dklima/SleepDeprivation/packages)
2. Download nightly builds (framework-dependent only)
3. **Note**: Development builds may be unstable

### 📦 Package Types Available

| Package Type       | Location                                                        | Update Frequency | Stability      | Size            |
| ------------------ | --------------------------------------------------------------- | ---------------- | -------------- | --------------- |
| **Release ZIPs**   | [Releases](https://github.com/dklima/SleepDeprivation/releases) | Manual releases  | ✅ Stable      | ~150KB / ~150MB |
| **NuGet Packages** | [Packages](https://github.com/dklima/SleepDeprivation/packages) | Every commit     | ⚠️ Development | ~150KB          |
| **Nightly ZIPs**   | [Packages](https://github.com/dklima/SleepDeprivation/packages) | Daily            | ⚠️ Development | ~150KB          |
| **Build Artifacts** | [Actions](https://github.com/dklima/SleepDeprivation/actions) | Every commit     | ⚠️ Development | ~150KB          |

## 🎮 Usage

### System Tray

- **Left click** on tray icon: Toggle sleep prevention on/off
- **Right click** on tray icon: Access context menu
- **Green icon** 🟢: Sleep prevention is active
- **Red icon** 🔴: Sleep prevention is inactive

### Window Interface

- **Activate/Deactivate button**: Toggle sleep prevention
- **Status indicator**: Visual circle showing current state
- **Minimize to Tray**: Hide window while keeping the app running

### Keyboard Shortcuts

- Close the window to minimize to tray (app keeps running)
- Use "Exit" from context menu to completely close the application

## 🛠️ Building from Source

### Prerequisites

- [.NET 9.0 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- Windows 10/11
- Visual Studio 2022 or VS Code (optional)

### Build Options

#### Small Build (Framework-Dependent)

```powershell
.\build-small.ps1
```

- **Output**: `builds-small/` folder
- **Size**: ~150KB per architecture
- **Requires**: .NET 9.0 Runtime on target machine

#### Portable Build (Self-Contained)

```powershell
.\build-portable.ps1
```

- **Output**: `builds-portable/` folder
- **Size**: ~150MB per architecture
- **Requires**: Nothing on target machine

#### Manual Build

```bash
# Framework-dependent (small)
dotnet publish --runtime win-x64 --configuration Release --self-contained false

# Self-contained (portable)
dotnet publish --runtime win-x64 --configuration Release --self-contained true
```

### Supported Architectures

- `win-x64` - 64-bit Intel/AMD (most common)
- `win-x86` - 32-bit Intel/AMD (legacy systems)
- `win-arm64` - ARM64 (Surface Pro X, etc.)

## 🏗️ Architecture

Built with modern .NET technologies:

- **Framework**: .NET 9.0
- **UI**: WPF (Windows Presentation Foundation)
- **System Integration**: Win32 APIs via P/Invoke
- **Tray Integration**: Hardcodet.NotifyIcon.Wpf

### Key Components

- `SetThreadExecutionState` - Windows API for sleep prevention
- Dynamic icon generation for tray indicators
- Proper resource cleanup and disposal
- Minimalist, efficient design

## 📋 System Requirements

- **OS**: Windows 10 version 1809 or later, Windows 11
- **.NET**: 9.0 Runtime (for framework-dependent builds)
- **Memory**: < 50MB RAM usage
- **Disk**: ~150KB - 150MB depending on build type
- **Permissions**: Standard user (no admin required)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Clone the repository
2. Open in Visual Studio 2022 or VS Code
3. Restore dependencies: `dotnet restore`
4. Build: `dotnet build`
5. Run: `dotnet run`

## 🐛 Troubleshooting

### Common Issues

**App doesn't prevent sleep**

- Check if the tray icon is green (active)
- Verify Windows power settings aren't overriding the app
- Run as administrator if needed (rare cases)

**Tray icon not visible**

- Check Windows notification area settings
- Ensure "Hidden icons" section in system tray

**Build errors**

- Ensure .NET 9.0 SDK is installed
- Clean and rebuild: `dotnet clean && dotnet build`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Hardcodet.NotifyIcon.Wpf](https://github.com/hardcodet/wpf-notifyicon) for system tray integration
- Microsoft .NET team for the excellent framework
- Windows API documentation and community

## 📈 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

---

**Made with ❤️ for productivity enthusiasts**

⭐ **Star this repository if you find it useful!**
