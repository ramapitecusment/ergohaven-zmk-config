#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
install_homebrew=0
open_karabiner=1

for arg in "$@"; do
  case "${arg}" in
    --install-homebrew)
      install_homebrew=1
      ;;
    --no-open)
      open_karabiner=0
      ;;
    -h|--help)
      cat <<'EOF'
Usage: ./host/macos/bootstrap.sh [--install-homebrew] [--no-open]

Installs Karabiner-Elements with Homebrew, installs the Imperial44
Windows-style shortcut rule, and enables Karabiner event modification for
EH Imperial44.

Options:
  --install-homebrew  Install Homebrew first if it is missing.
  --no-open           Do not open Karabiner-Elements after setup.
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: ${arg}" >&2
      exit 1
      ;;
  esac
done

find_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    echo /opt/homebrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    echo /usr/local/bin/brew
  fi
}

brew_bin="$(find_brew || true)"
if [[ -z "${brew_bin}" ]]; then
  if [[ "${install_homebrew}" == 1 ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew_bin="$(find_brew || true)"
  else
    cat >&2 <<'EOF'
Homebrew is not installed.

Run one of these, then rerun bootstrap:

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ./host/macos/bootstrap.sh

Or let this script run the official installer:

  ./host/macos/bootstrap.sh --install-homebrew
EOF
    exit 1
  fi
fi

eval "$("${brew_bin}" shellenv)"

if ! brew list --cask karabiner-elements >/dev/null 2>&1; then
  brew install --cask karabiner-elements
fi

"${repo_root}/host/macos/install-karabiner-rule.sh"

if [[ "${open_karabiner}" == 1 ]]; then
  open /Applications/Karabiner-Elements.app
fi

cat <<'EOF'
Setup complete.

If shortcuts do not work:
  1. Approve Karabiner permissions in System Settings if prompted.
  2. Check Karabiner-Elements -> Devices -> EH Imperial44 -> Modify events.
  3. Run ./host/macos/doctor.sh.

Quick test in a normal text field:
  Ctrl+A should select all.
  Ctrl+D should bookmark/add favorite where Command+D normally does.
  Alt+Tab should switch apps.
  Alt+Shift should switch the input source when released.
  Alt+Shift+Tab should move backward without switching the input source.
EOF
