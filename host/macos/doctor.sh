#!/usr/bin/env bash
set -euo pipefail

karabiner_cli="/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"
config="${HOME}/.config/karabiner/karabiner.json"

section() {
  printf '\n== %s ==\n' "$1"
}

section "Homebrew"
if command -v brew >/dev/null 2>&1; then
  brew --version | head -1
elif [[ -x /opt/homebrew/bin/brew ]]; then
  /opt/homebrew/bin/brew --version | head -1
elif [[ -x /usr/local/bin/brew ]]; then
  /usr/local/bin/brew --version | head -1
else
  echo "missing"
fi

section "Karabiner"
if [[ -x "${karabiner_cli}" ]]; then
  "${karabiner_cli}" --version
  "${karabiner_cli}" --show-current-profile-name || true
  "${karabiner_cli}" --show-settings-window-guidance || true
else
  echo "karabiner_cli missing"
fi

section "Connected Devices"
if [[ -x "${karabiner_cli}" ]]; then
  "${karabiner_cli}" --list-connected-devices | python3 -m json.tool
fi

section "Config Summary"
if [[ -f "${config}" ]]; then
  python3 - "${config}" <<'PY'
import json
import sys
from pathlib import Path

config = json.loads(Path(sys.argv[1]).read_text())
profiles = config.get("profiles", [])
profile = next((p for p in profiles if p.get("selected")), profiles[0] if profiles else {})
print("profile:", profile.get("name"))
print("rules:")
for rule in profile.get("complex_modifications", {}).get("rules", []):
    print("  -", rule.get("description"), f"({len(rule.get('manipulators', []))} manipulators)")
print("devices:")
for device in profile.get("devices", []):
    identifiers = device.get("identifiers", {})
    if identifiers.get("vendor_id") == 7504 and identifiers.get("product_id") == 24926:
        print("  - EH Imperial44:", "Modify events enabled" if device.get("ignore") is False else "Modify events disabled")
    if (
        identifiers.get("vendor_id") == 7511
        and identifiers.get("product_id") == 64096
        and identifiers.get("is_pointing_device") is True
    ):
        print("  - 2.4G mouse:", "Modify events enabled" if device.get("ignore") is False else "Modify events disabled")
PY
else
  echo "missing: ${config}"
fi

section "Expected Manual Checks"
cat <<'EOF'
In Karabiner-Elements:
  Devices -> EH Imperial44 -> Modify events must be enabled.
  Devices -> 2.4G Wireless Device (mouse) -> Modify events must be enabled.

In a normal text field:
  Ctrl+A should select all.
  Ctrl+D should behave like Command+D.
  Ctrl+Shift+F should open project-wide search in an IDE.
  Alt+Tab should switch apps.
  Alt+Esc should switch windows of the current app.
  Alt+Shift+Esc should switch those windows in reverse.
  Alt+Shift should switch the input source when released.
  Alt+Shift+Tab should move backward without switching the input source.
EOF
