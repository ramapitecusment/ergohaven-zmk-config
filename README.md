# Ergohaven ZMK Config

Personal ZMK configuration for Ergohaven keyboards.

## Imperial44 Power Management

The wireless Imperial44 enters ZMK deep sleep after one hour of inactivity (`CONFIG_ZMK_IDLE_SLEEP_TIMEOUT=3600000`). Normal idle power saving remains enabled, so Bluetooth stays connected during shorter breaks. Changing this value requires rebuilding and flashing both keyboard halves.

## Imperial44 Windows Shortcuts on macOS

This repo includes host OS settings for using Windows-style shortcuts on macOS with the Imperial44.

- macOS Karabiner rule: `host/karabiner/imperial44-windows-shortcuts.json`
- Setup notes: `docs/imperial44-windows-shortcuts-on-macos.md`

The setup is host-side. It does not require changing ZMK firmware.

It maps common Windows actions to their macOS equivalents for the `EH Imperial44` device:

- `Ctrl+C/X/V/A/Z/Y/S/F/R/T/W/N/O/P/L`
- `Ctrl+Shift+F` for project-wide search in IDEs
- `Alt+Tab`
- `Alt+Esc` / `Alt+Shift+Esc` for switching windows of the current application
- `Alt+F4`
- `Alt+Left` / `Alt+Right` for browser/Finder back/forward
- `Ctrl+H` for browser history without triggering macOS Hide
- `Ctrl+Shift+T` for reopening the last closed browser tab/page
- `Ctrl+Shift+R`, `Ctrl+Shift+N`, and `Ctrl+Shift+P`
- `Ctrl+E/K/J/U`, `F5`, and `Ctrl+F5` with browser-specific macOS equivalents
- `Ctrl+G`, `Ctrl+Shift+G`, and `Ctrl+Shift+W`
- `Ctrl+left click` as macOS `Command+left click` with the configured 2.4G mouse
- `Ctrl+Shift+.` to show or hide hidden files in Finder
- `PrintScreen` for the macOS screenshot panel and `Shift+PrintScreen` for area capture
- `Ctrl+=`, `Ctrl+-`, and `Ctrl+0` for zoom
- `Alt+Shift` for language switching on chord release, without breaking `Alt+Shift+Tab`
- `Win+Space` for language switching
- Context-aware Windows-style text navigation and selection for `Home`, `End`, word/document movement, and word deletion

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
