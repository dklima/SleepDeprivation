@echo off
setlocal enabledelayedexpansion
echo ===============================================
echo Sleep Deprivation - Large Portable Builds
echo Self-contained builds (~200MB each)
echo No .NET installation required!
echo ===============================================

REM Clean previous builds
if exist "build-portable" (
    echo Cleaning previous builds...
    rmdir /s /q "build-portable"
)
mkdir "build-portable"

REM Restore dependencies
echo.
echo Restoring dependencies...
dotnet restore
if %errorlevel% neq 0 (
    echo Failed to restore dependencies!
    exit /b 1
)

REM Build for each architecture
echo.
echo Building Windows x64 (self-contained)...
dotnet publish --runtime win-x64 --configuration Release --output build-portable/windows-x64 --self-contained true --verbosity minimal /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true

echo.
echo Building Windows x86 (self-contained)...
dotnet publish --runtime win-x86 --configuration Release --output build-portable/windows-x86 --self-contained true --verbosity minimal /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true

echo.
echo Building Windows ARM64 (self-contained)...
dotnet publish --runtime win-arm64 --configuration Release --output build-portable/windows-arm64 --self-contained true --verbosity minimal /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true

echo.
echo ===============================================
echo BUILD COMPLETE!
echo ===============================================

REM Show file sizes
echo.
echo File sizes:
if exist "build-portable\windows-x64\SleepDeprivation.exe" (
    for %%F in ("build-portable\windows-x64\SleepDeprivation.exe") do (
        set /a size=%%~zF/1024/1024
        echo windows-x64: approximately !size! MB
    )
)
if exist "build-portable\windows-x86\SleepDeprivation.exe" (
    for %%F in ("build-portable\windows-x86\SleepDeprivation.exe") do (
        set /a size=%%~zF/1024/1024
        echo windows-x86: approximately !size! MB
    )
)
if exist "build-portable\windows-arm64\SleepDeprivation.exe" (
    for %%F in ("build-portable\windows-arm64\SleepDeprivation.exe") do (
        set /a size=%%~zF/1024/1024
        echo windows-arm64: approximately !size! MB
    )
)

echo.
echo PORTABLE executables created in build-portable folder!
echo No .NET installation required on target system!
echo Simply copy the .exe file and run on any Windows machine!

pause