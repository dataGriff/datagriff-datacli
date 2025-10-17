# learn-go-cli-cobra

1. mkdir datacli
2. go mod init github.com/datagriff/datacli
3. go install github.com/spf13/cobra-cli@latest
4. cobra-cli init
5. goreleaser init

## Windows Installation

### Quick Install (Recommended)

```powershell
iwr -useb https://raw.githubusercontent.com/dataGriff/learn-go-cli-cobra/main/install/windows.ps1 | iex
```

### Manual Download

1. Download the script: [windows.ps1](install/windows.ps1)
2. Run in PowerShell: `.\windows.ps1`

### After Installation

```cmd
datagriff-datacli list
datagriff-datacli --help
```
