# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-08-06

### Security
- **CRITICAL**: Fixed GDI handle memory leak in CreateTrayIcon method
- **HIGH**: Updated Hardcodet.NotifyIcon.Wpf from v1.1.0 to v2.0.1 (addresses known vulnerabilities)
- Added DestroyIcon P/Invoke to properly release GDI resources
- Implemented try-finally blocks for secure resource cleanup
- Added security configurations to project file (TreatWarningsAsErrors, EnableNETAnalyzers)
- Fixed placeholder values in dependabot.yml configuration
- Added SECURITY.md with vulnerability reporting policy

### Added
- Comprehensive security documentation
- Enhanced build security with static analysis
- Memory leak prevention measures

## [1.0.0] - 2025-08-06

### Added

- Initial release of Sleep Deprivation
- System tray integration with dynamic colored icons
- Sleep prevention using Windows API (`SetThreadExecutionState`)
- Display sleep prevention (keeps monitors active)
- Left-click toggle functionality on tray icon
- Right-click context menu with Enable/Disable options
- Main window with visual status indicator
- Green/red status circle and text indicators
- Minimize to tray functionality
- Automatic startup minimized
- Framework-dependent builds for ultra-small size (~150KB)
- Self-contained builds for portability (~150MB)
- Multi-architecture support (x64, x86, ARM64)
- Professional build scripts (PowerShell and Batch)
- Comprehensive documentation and README
- MIT License

### Technical Details

- Built with .NET 9.0 and WPF
- Uses `Hardcodet.NotifyIcon.Wpf` for system tray integration
- Dynamic icon generation with GDI+ graphics
- Proper resource cleanup and disposal
- Windows API integration via P/Invoke
- Clean shutdown handling

### Build Options

- **Framework-Dependent**: ~150KB (requires .NET 9.0 Runtime)
- **Self-Contained**: ~150MB (portable, no dependencies)
- Support for Windows x64, x86, and ARM64 architectures

### Features

- ✅ Prevents system sleep/hibernation
- ✅ Prevents display sleep/screen saver
- ✅ System tray integration
- ✅ Visual status indicators
- ✅ One-click toggle
- ✅ Context menu controls
- ✅ Ultra-lightweight design
- ✅ Professional UI in English
- ✅ Multi-architecture builds
- ✅ Comprehensive documentation
