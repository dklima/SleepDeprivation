@echo off
echo ========================================
echo Sleep Deprivation - Multi-Architecture Build
echo ========================================

REM Create builds directory
if exist builds rmdir /s /q builds
mkdir builds

echo.
echo Building for x64...
echo ----------------------------------------
dotnet publish --runtime win-x64 --configuration Release --output builds\windows-x64 --self-contained true --verbosity minimal
if %errorlevel% equ 0 (
    echo x64 build completed successfully!
) else (
    echo x64 build failed!
)

echo.
echo Building for x86...
echo ----------------------------------------
dotnet publish --runtime win-x86 --configuration Release --output builds\windows-x86 --self-contained true --verbosity minimal
if %errorlevel% equ 0 (
    echo x86 build completed successfully!
) else (
    echo x86 build failed!
)

echo.
echo Building for ARM64...
echo ----------------------------------------
dotnet publish --runtime win-arm64 --configuration Release --output builds\windows-arm64 --self-contained true --verbosity minimal
if %errorlevel% equ 0 (
    echo ARM64 build completed successfully!
) else (
    echo ARM64 build failed!
)

echo.
echo ========================================
echo Build Summary
echo ========================================
echo.

if exist builds\windows-x64\SleepDeprivation.exe (
    echo x64    - builds\windows-x64\SleepDeprivation.exe
) else (
    echo x64    - Build failed
)

if exist builds\windows-x86\SleepDeprivation.exe (
    echo x86    - builds\windows-x86\SleepDeprivation.exe
) else (
    echo x86    - Build failed
)

if exist builds\windows-arm64\SleepDeprivation.exe (
    echo ARM64  - builds\windows-arm64\SleepDeprivation.exe
) else (
    echo ARM64  - Build failed
)

echo.
echo All builds completed! Check the 'builds' folder for executables.
pause