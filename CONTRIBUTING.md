

## Setup

- [Install task](https://taskfile.dev/docs/installation)

```bash
curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | sudo -E bash
sudo apt install task
```

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

source ~/.bashrc

brew --version
```

```bash
go install github.com/spf13/cobra-cli@latest
```
