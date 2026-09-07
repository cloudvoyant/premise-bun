#!/usr/bin/env bash
: <<DOCUMENTATION
Installer script for premise-bun

Downloads and installs the latest release from GitHub.

Usage:
  curl -fsSL https://raw.githubusercontent.com/premise-bun-io/premise-bun/main/install.sh | bash
  wget -qO- https://raw.githubusercontent.com/premise-bun-io/premise-bun/main/install.sh | bash

Options:
  --version VERSION    Install specific version (default: latest)
  --install-dir DIR    Installation directory (default: ~/.local/bin)
  --help               Show this help message
DOCUMENTATION

set -euo pipefail

# CONFIGURATION ----------------------------------------------------------------
DEFAULT_INSTALL_DIR="$HOME/.local/bin"
GITHUB_ORG="premise-bun-io"
GITHUB_REPO="premise-bun"
INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"
VERSION="${VERSION:-latest}"

# ARGUMENT PARSING -------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case $1 in
    --version)
        VERSION="$2"
        shift 2
        ;;
    --install-dir)
        INSTALL_DIR="$2"
        shift 2
        ;;
    -h | --help)
        cat <<'EOF'
Installer for premise-bun

Usage:
  curl -fsSL https://raw.githubusercontent.com/premise-bun-io/premise-bun/main/install.sh | bash
  bash install.sh [OPTIONS]

Options:
  --version VERSION    Install specific version (default: latest)
  --install-dir DIR    Installation directory (default: ~/.local/bin)
  -h, --help           Show this help message

Examples:
  # Install latest version
  bash install.sh

  # Install specific version
  bash install.sh --version v1.2.3

  # Install to custom directory
  bash install.sh --install-dir /usr/local/bin
EOF
        exit 0
        ;;
    *)
        echo "Unknown option: $1" >&2
        echo "Run with --help for usage information" >&2
        exit 1
        ;;
    esac
done

# UTILITY FUNCTIONS ------------------------------------------------------------
log_info() {
    echo "[INFO] $1"
}

log_success() {
    echo "[SUCCESS] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

detect_platform() {
    local os=""
    local arch=""

    # Detect OS
    case "$(uname -s)" in
    Linux*) os="linux" ;;
    Darwin*) os="darwin" ;;
    *)
        log_error "Unsupported operating system: $(uname -s)"
        exit 1
        ;;
    esac

    # Detect architecture
    case "$(uname -m)" in
    x86_64) arch="amd64" ;;
    aarch64) arch="arm64" ;;
    arm64) arch="arm64" ;;
    *)
        log_error "Unsupported architecture: $(uname -m)"
        exit 1
        ;;
    esac

    echo "${os}-${arch}"
}

download_release() {
    local version=$1
    local platform=$2
    local download_url=""

    if [ "$version" = "latest" ]; then
        log_info "Fetching latest release"
        download_url="https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/releases/latest/download/premise-bun-${platform}"
    else
        log_info "Fetching version ${version}"
        download_url="https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/releases/download/${version}/premise-bun-${platform}"
    fi

    log_info "Downloading from: ${download_url}"

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$download_url" -o "/tmp/premise-bun"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "/tmp/premise-bun" "$download_url"
    else
        log_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi
}

install_binary() {
    local install_path="${INSTALL_DIR}/premise-bun"

    # Create installation directory if it doesn't exist
    mkdir -p "$INSTALL_DIR"

    # Move binary to installation directory
    mv "/tmp/premise-bun" "$install_path"
    chmod +x "$install_path"

    log_success "Installed premise-bun to: $install_path"
}

verify_installation() {
    if command -v premise-bun >/dev/null 2>&1; then
        log_success "premise-bun is now available in your PATH"
        log_info "Version: $(premise-bun --version 2>/dev/null || echo 'unknown')"
    elif [ -x "${INSTALL_DIR}/premise-bun" ]; then
        log_success "premise-bun installed successfully"
        log_info "Add ${INSTALL_DIR} to your PATH to use premise-bun"
        log_info "Example: export PATH=\"${INSTALL_DIR}:\$PATH\""
    else
        log_error "Installation verification failed"
        exit 1
    fi
}

# MAIN -------------------------------------------------------------------------
main() {
    log_info "Installing premise-bun"

    # Detect platform
    PLATFORM=$(detect_platform)
    log_info "Detected platform: $PLATFORM"

    # Download release
    download_release "$VERSION" "$PLATFORM"

    # Install binary
    install_binary

    # Verify installation
    verify_installation

    log_success "Installation complete!"
}

main
