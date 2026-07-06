# Ergohaven ZMK Config

Personal ZMK configuration for Ergohaven keyboards.

## Imperial44 Windows Shortcuts on macOS

This repo includes host OS settings for using Windows-style shortcuts on macOS with the Imperial44.

- macOS Karabiner rule: `host/karabiner/imperial44-windows-shortcuts.json`
- Setup notes: `docs/imperial44-windows-shortcuts-on-macos.md`

The setup is host-side. It does not require changing ZMK firmware.

It maps common Windows actions to their macOS equivalents for the `EH Imperial44` device:

- `Ctrl+C/X/V/A/Z/Y/S/F/R/T/W/N/O/P/L`
- `Alt+Tab`
- `Alt+F4`
- `Ctrl+Shift+T` for reopening the last closed browser tab/page
- `Alt+Shift` for language switching
- `Win+Space` for language switching
- Windows-style text navigation for `Home`, `End`, `Ctrl+Left`, `Ctrl+Right`, and `Ctrl+Backspace`

On macOS, run:

```sh
./host/macos/bootstrap.sh
```

If Homebrew is not installed yet, either install it first or let the bootstrap run the official installer:

```sh
./host/macos/bootstrap.sh --install-homebrew
```

The bootstrap installs Karabiner-Elements if needed, enables the shortcut rule, and turns on `Modify events` for `EH Imperial44`.

If shortcuts do not work, check:

```text
Karabiner-Elements -> Devices -> EH Imperial44 -> Modify events
```

Then run:

```sh
./host/macos/doctor.sh
```
