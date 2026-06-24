# Imperial44 Windows Shortcuts on macOS

Goal: use the same user-facing shortcuts on macOS that you use on Windows.

This is a host-side Karabiner setup. It does not require changing the ZMK firmware.

## Enabled Shortcuts

- `Ctrl+C/X/V/A/Z/Y/S/F/R/T/W/N/O/P/L` -> common macOS `Command` shortcuts.
- `Alt+Tab` -> macOS app switcher.
- `Alt+Shift+Tab` -> reverse macOS app switcher.
- `Alt+F4` -> close the current macOS window/tab with `Command+W`.
- `Alt+Shift` -> switch input source.
- `Win+Space` -> switch input source.
- `Home` / `End` -> beginning/end of line.
- `Ctrl+Left` / `Ctrl+Right` -> previous/next word.
- `Ctrl+Backspace` -> delete previous word.

The installer enables Karabiner event modification for the `EH Imperial44` device:

- vendor id: `7504`
- product id: `24926`

## Bootstrap Install

```sh
./host/macos/bootstrap.sh
```

If Homebrew is missing:

```sh
./host/macos/bootstrap.sh --install-homebrew
```

The bootstrap does three things:

- Installs Karabiner-Elements if needed.
- Installs and enables `host/karabiner/imperial44-windows-shortcuts.json`.
- Enables `Modify events` for `EH Imperial44`.

To reinstall only the Karabiner rule:

```sh
./host/macos/install-karabiner-rule.sh
```

If shortcuts do not work, check this manually:

```text
Karabiner-Elements -> Devices -> EH Imperial44 -> Modify events
```

## macOS Requirements

Karabiner-Elements must be installed and approved in macOS System Settings.

Run the doctor script for a local status report:

```sh
./host/macos/doctor.sh
```

If language switching does not work, check that macOS has at least two input sources enabled:

```text
System Settings -> Keyboard -> Text Input -> Edit
```

For your current setup, macOS has `ABC`, `Russian`, and `Kazakh` enabled.

## Notes

This setup intentionally makes macOS behave less like a Mac and more like Windows for the Imperial44. Terminal apps may still need app-specific exceptions if you want shell control keys such as `Ctrl+C` to interrupt instead of copying.
