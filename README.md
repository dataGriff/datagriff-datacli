# datagriff-datacli

1. mkdir datacli
2. go mod init github.com/datagriff/datacli
3. go install github.com/spf13/cobra-cli@latest
4. cobra-cli init
5. goreleaser init

## MacOS / Linux Installation

### Homebrew (Recommended)

```bash
brew install dataGriff/tap/datagriff-datacli
```

## Windows Installation

### Quick Install (Recommended)

```powershell
iwr -useb https://raw.githubusercontent.com/dataGriff/datagriff-datacli/main/install/windows.ps1 | iex
```

### Manual Download

1. Download the script: [windows.ps1](install/windows.ps1)
2. Run in PowerShell: `.\windows.ps1`

### After Installation

```cmd
datagriff-datacli list
datagriff-datacli --help
```
