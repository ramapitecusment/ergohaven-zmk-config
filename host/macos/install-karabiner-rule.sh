#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
src="${repo_root}/host/karabiner/imperial44-windows-shortcuts.json"
dst_dir="${HOME}/.config/karabiner/assets/complex_modifications"
dst="${dst_dir}/imperial44-windows-shortcuts.json"
config="${HOME}/.config/karabiner/karabiner.json"
karabiner_cli="/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"

if [[ ! -f "${src}" ]]; then
  echo "Missing Karabiner rule: ${src}" >&2
  exit 1
fi

mkdir -p "${dst_dir}"
cp "${src}" "${dst}"

if [[ -x "${karabiner_cli}" ]]; then
  "${karabiner_cli}" --lint-complex-modifications "${dst}"
fi

python3 - "${dst}" "${config}" <<'PY'
import json
import sys
from pathlib import Path

rule_path = Path(sys.argv[1])
config_path = Path(sys.argv[2])
rule_payload = json.loads(rule_path.read_text())
new_rules = rule_payload["rules"]

if config_path.exists():
    config = json.loads(config_path.read_text())
else:
    config = {"profiles": [{"name": "Default profile", "selected": True}]}

profiles = config.setdefault("profiles", [])
if not profiles:
    profiles.append({"name": "Default profile", "selected": True})

profile = next((item for item in profiles if item.get("selected")), profiles[0])
profile.setdefault("selected", True)
devices = profile.setdefault("devices", [])
imperial_identifiers = {
    "vendor_id": 7504,
    "product_id": 24926,
    "is_keyboard": True,
    "is_pointing_device": True,
}
for device in devices:
    identifiers = device.get("identifiers", {})
    if (
        identifiers.get("vendor_id") == imperial_identifiers["vendor_id"]
        and identifiers.get("product_id") == imperial_identifiers["product_id"]
    ):
        device["ignore"] = False
        break
else:
    devices.append({
        "identifiers": imperial_identifiers,
        "ignore": False,
    })

complex_modifications = profile.setdefault("complex_modifications", {})
rules = complex_modifications.setdefault("rules", [])

remove_descriptions = {
    "Imperial44 RuEn input-source switching",
    "Ctrl+Shift+1 selects ABC; Ctrl+Shift+2 selects Russian",
    "Imperial44 Windows-style shortcuts",
    "Windows-style shortcuts on macOS",
}
rules[:] = [
    rule
    for rule in rules
    if rule.get("description") not in remove_descriptions
]
rules.extend(new_rules)

config_path.parent.mkdir(parents=True, exist_ok=True)
config_path.write_text(json.dumps(config, indent=4) + "\n")
PY

cat <<EOF
Installed:
  ${dst}

Enabled in:
  ${config}

The installer also enables "Modify events" for EH Imperial44 in Karabiner's Devices settings.

Open /Applications/Karabiner-Elements.app if macOS permissions are not approved yet.
EOF
