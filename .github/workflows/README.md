# GitHub Actions Workflows

This repository uses GitHub Actions for continuous integration, deployment, and release management.

## Workflows

### 🔨 Build and Test (`build.yml`)
**Trigger**: Push to main/develop, Pull Requests, Manual
- Builds for all architectures (x64, x86, ARM64)
- Creates both framework-dependent and self-contained builds
- Runs tests and code quality checks
- Uploads artifacts for 7 days

### 📦 Release (`release.yml`)
**Trigger**: Version tags (v*.*.*), Manual
- Creates GitHub releases automatically
- Builds and uploads all architecture variants
- Generates SHA256 checksums
- Creates both small (~150KB) and portable (~150MB) versions

### 🔒 Security (`security.yml`)
**Trigger**: Push to main, PRs, Weekly schedule, Manual
- Scans for vulnerable dependencies
- Checks for outdated packages
- Runs CodeQL security analysis
- Performs dependency review on PRs

### ✅ PR Validation (`pr-validation.yml`)
**Trigger**: Pull Request events
- Validates no large files (>10MB)
- Checks for binary files
- Verifies code formatting
- Runs build and tests
- Comments build size report on PR

### 🌙 Continuous Deployment (`continuous-deployment.yml`)
**Trigger**: Push to main, Manual
- Creates nightly builds
- Auto-deploys to nightly release
- Keeps only last 3 nightly releases
- Framework-dependent builds only

### 📦 Publish Packages (`packages.yml`)
**Trigger**: Push to main, Releases, Manual
- Publishes NuGet packages to GitHub Packages
- Creates binary ZIP packages for all architectures
- Builds Docker containers (Windows)
- Automatic versioning for dev/release builds

## Configuration

### Secrets Required
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions

### Environment Variables
- `DOTNET_VERSION`: .NET SDK version (currently 9.0.x)
- `PROJECT_NAME`: Project name (SleepDeprivation)

## Usage

### Creating a Release
1. Tag your commit: `git tag v1.0.0`
2. Push the tag: `git push origin v1.0.0`
3. The release workflow will automatically:
   - Create a GitHub release
   - Build all variants
   - Upload ZIP files
   - Generate checksums

### Manual Workflow Runs
All workflows support manual triggering via GitHub UI:
1. Go to Actions tab
2. Select the workflow
3. Click "Run workflow"
4. Fill in any required inputs

### Build Artifacts
Build artifacts are available for 7 days after each build:
- Framework-dependent: ~150KB per architecture
- Self-contained: ~150MB per architecture

## Build Matrix

| Runtime | Framework-Dependent | Self-Contained | NuGet Package | Docker |
|---------|-------------------|----------------|---------------|--------|
| win-x64 | ✅ ~150KB | ✅ ~163MB | ✅ ZIP | ✅ Windows |
| win-x86 | ✅ ~123KB | ✅ ~152MB | ✅ ZIP | - |
| win-arm64 | ✅ ~150KB | ✅ ~176MB | ✅ ZIP | - |

### Package Types

- **GitHub Releases**: ZIP files for stable versions
- **GitHub Packages**: NuGet packages + binary ZIPs for dev versions
- **Docker Hub**: Windows containers (x64 only)

## Maintenance

### Dependabot
Configured to check for updates weekly:
- NuGet packages
- GitHub Actions versions

### Security Updates
- Automatic security scanning on every push
- Weekly scheduled scans
- CodeQL analysis for code vulnerabilities

## Workflow Status Badges

Add these to your README:

```markdown
[![Build and Test](https://github.com/yourusername/sleep-deprivation/actions/workflows/build.yml/badge.svg)](https://github.com/yourusername/sleep-deprivation/actions/workflows/build.yml)
[![Security](https://github.com/yourusername/sleep-deprivation/actions/workflows/security.yml/badge.svg)](https://github.com/yourusername/sleep-deprivation/actions/workflows/security.yml)
[![Release](https://github.com/yourusername/sleep-deprivation/actions/workflows/release.yml/badge.svg)](https://github.com/yourusername/sleep-deprivation/actions/workflows/release.yml)
```

## Troubleshooting

### Build Failures
- Check .NET SDK version compatibility
- Verify all NuGet packages are restored
- Review build logs in Actions tab

### Release Issues
- Ensure tag follows v*.*.* format
- Check GITHUB_TOKEN permissions
- Verify CHANGELOG.md has entry for version

### Large Artifacts
- Self-contained builds are large (~150MB)
- Consider using framework-dependent for distribution
- Use artifact retention policies to manage storage