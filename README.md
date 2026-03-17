# Woodpecker Opengrep Plugin

A Woodpecker CI plugin for running [Opengrep](https://github.com/opengrep/opengrep) static code analysis scans.

Opengrep is a community fork of Semgrep that keeps static analysis open and accessible. It provides semantic code search, security vulnerability detection, and supports 30+ languages.

## Usage

```yaml
steps:
  - name: opengrep
    image: ghcr.io/kalvadtech/woodpecker-opengrep
    settings:
      rules: auto
```

## Settings

| Setting | Description | Default |
|---------|-------------|---------|
| `rules` | Rules to use for scanning. Can be `auto` (built-in rules) or a path to custom rules directory. | `auto` |
| `target` | Target directory to scan. | `.` |
| `config` | Path to config file. | - |
| `sarif_output` | Output file for SARIF results. | - |
| `error` | Exit with code 1 if findings are detected. Useful for failing CI builds on security issues. | `false` |
| `exclude` | Patterns to exclude from scanning. | - |

## Examples

### Scan with built-in rules

```yaml
steps:
  - name: opengrep
    image: ghcr.io/kalvadtech/woodpecker-opengrep
    settings:
      rules: auto
```

### Scan with custom rules

```yaml
steps:
  - name: opengrep
    image: ghcr.io/kalvadtech/woodpecker-opengrep
    settings:
      rules: ./rules
      target: ./src
```

### Fail CI on findings

```yaml
steps:
  - name: opengrep
    image: ghcr.io/kalvadtech/woodpecker-opengrep
    settings:
      rules: auto
      error: true
```

### SARIF output

```yaml
steps:
  - name: opengrep
    image: ghcr.io/kalvadtech/woodpecker-opengrep
    settings:
      rules: auto
      sarif_output: opengrep-results.sarif
```

### Exclude patterns

```yaml
steps:
  - name: opengrep
    image: ghcr.io/kalvadtech/woodpecker-opengrep
    settings:
      rules: auto
      exclude: "*.test.js,test/**,vendor/**"
```

## Building

```bash
# Build for local testing
make build

# Push to registry
make push
```

Multi-arch images (linux/amd64, linux/arm64) are built automatically.
