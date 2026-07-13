# Imperial44 Windows Shortcuts on macOS

Goal: use the same user-facing shortcuts on macOS that you use on Windows.

This is a host-side Karabiner setup. It does not require changing the ZMK firmware.

## Enabled Shortcuts

- `Ctrl+C/X/V/A/Z/Y/S/F/R/T/W/N/O/P/L` -> common macOS `Command` shortcuts.
- `Alt+Tab` -> macOS app switcher.
- `Alt+Shift+Tab` -> reverse macOS app switcher.
- `Alt+F4` -> close the current macOS window/tab with `Command+W`.
- `Alt+Left` / `Alt+Right` -> browser/Finder back/forward.
- `Ctrl+H` -> browser history (`Command+Y` in Chromium/Safari, `Command+Shift+H` in Firefox), never macOS Hide.
- `Ctrl+Shift+T` -> reopen the last closed browser tab/page.
- `Ctrl+Shift+R` -> hard reload in browsers.
- `F5` / `Ctrl+F5` -> reload / hard reload in browsers.
- `Ctrl+Shift+N` -> new private/incognito window in browsers that use this shortcut.
- `Ctrl+Shift+P` -> new private window in Firefox and command palette in apps that use the Mac equivalent.
- `Ctrl+E` / `Ctrl+K` -> focus browser address/search UI.
- `Ctrl+J` -> browser downloads.
- `Ctrl+U` -> page source in Chromium browsers while retaining the normal macOS mapping elsewhere.
- `Ctrl+G` / `Ctrl+Shift+G` -> next/previous search result.
- `Ctrl+Shift+W` -> close the current window.
- `Ctrl+left click` -> `Command+left click`, including when the mouse is a separate HID device.
- `Ctrl+Shift+.` -> show or hide hidden files in Finder.
- `PrintScreen` -> open the macOS Screenshot panel (`Shift+Command+5`).
- `Shift+PrintScreen` -> capture a selected area (`Shift+Command+4`).
- `Ctrl+=` / `Ctrl+-` / `Ctrl+0` -> zoom in/out/reset.
- `Alt+Shift` -> switch input source when the clean chord is released.
- `Win+Space` -> switch input source.
- `Home` / `End` -> beginning/end of line while an accessibility text element is focused; otherwise the native event passes through.
- `Ctrl+Left` / `Ctrl+Right` -> previous/next word.
- `Ctrl+Shift+Left` / `Ctrl+Shift+Right` -> select previous/next word.
- `Ctrl+Home` / `Ctrl+End` -> beginning/end of document.
- `Ctrl+Shift+Home` / `Ctrl+Shift+End` -> select to beginning/end of document.
- `Ctrl+Backspace` -> delete previous word.
- `Ctrl+Delete` -> delete next word.

`Alt+Tab` uses Karabiner's native `to_if_other_key_pressed` behavior so holding `Alt` keeps the macOS app switcher open like Windows, instead of sending a brittle one-shot `Command+Tab`.

`Alt+Shift` is delayed until the chord is released without another key. This preserves Windows-style `Alt+Shift+Tab`: it moves backward in the app switcher without also changing the input source. Both key orders, `Alt` then `Shift` and `Shift` then `Alt`, are supported.

`Ctrl+left click` is handled on the configured 2.4G mouse (vendor `7511`, product `64096`) while Control is held on the Imperial44. The installer enables `Modify events` for both devices; holding Shift at the same time is preserved.

`Home` and `End` use Karabiner 16's `accessibility.focused_ui_element.role_string` variable. This prevents `Home` from becoming `Command+Left` on a normal browser page, where Chromium would interpret it as browser Back. If an app does not expose accessibility focus information, the original `Home` or `End` event passes through.

On the current Imperial44 keymap, `PrintScreen` is `MO2+B`. Hold either Shift while pressing that chord to jump directly to area selection.

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

## Native Karabiner Surfaces

The setup uses supported Karabiner surfaces:

- `karabiner_cli --lint-complex-modifications` validates the generated rule before install.
- `karabiner_cli --show-settings-window-guidance` checks permissions, driver status, and virtual keyboard readiness in `doctor.sh`.
- `karabiner_cli --list-connected-devices` confirms the Imperial44 vendor/product ids.
- Complex modification JSON is installed under `~/.config/karabiner/assets/complex_modifications/` and enabled in `~/.config/karabiner/karabiner.json`.

Useful Karabiner features to consider later:

- `frontmost_application_if` / `frontmost_application_unless`: app-specific exceptions, for example keeping real shell `Ctrl+C` in Terminal while using Windows copy elsewhere.
- `input_source_if` / `input_source_unless`: mappings that only run for a specific macOS input source.
- `to.select_input_source`: direct input source selection if you later want a dedicated English/Russian/Kazakh switch key.
- `to.from_event`: temporary pass-through modes for apps where the Windows remaps should be disabled.
- JavaScript complex modifications: useful if the JSON grows hard to maintain, but the current generated JSON is simpler and works with the CLI linter.

## Notes

This setup intentionally makes macOS behave less like a Mac and more like Windows for the Imperial44. Terminal apps may still need app-specific exceptions if you want shell control keys such as `Ctrl+C` to interrupt instead of copying.
