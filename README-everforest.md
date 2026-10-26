# Everforest on niri + DMS

Everything follows the system appearance. The rule everywhere: **dark uses soft
contrast, light uses hard**. You switch light/dark in DMS and the rest follows.

| Part | How it follows |
| --- | --- |
| DMS (Dux Shell) | Custom theme `dms/.config/dms/themes/everforest.json` |
| niri | `niri/.config/niri/everforest.kdl` (colours work on both modes) |
| GTK 3 / GTK 4 | `everforest-follow` switches `gtk-theme` and the `~/.config/gtk-4.0` links |
| Qt | `everforest-follow` switches the qt6ct colour scheme (Fusion style) |
| Ghostty, Neovim, tmux, lazygit | Already set up, `dark:`/`light:` themes |
| Firefox, Obsidian | Follow the portal `color-scheme`, manual setup below |
| Spotify | Spicetify + Comfy, `everforest-follow` switches the colour scheme and re-applies (restarts Spotify if open) |

## 1. Stow

`~/.config/niri` and `~/.config/dms` must already exist as real folders (niri
and DMS create them on first start), so stow links files into them instead of
linking the whole folder. Move niri's generated `config.kdl` out of the way
first, the one from the dotfiles replaces it:

```sh
mkdir -p ~/.config/niri ~/.config/dms ~/.config/qt6ct ~/.local/bin
mv ~/.config/niri/config.kdl ~/.config/niri/config.kdl.default
cd ~/.dotfiles
stow --no-folding dms niri qt everforest
```

## 2. niri config

`niri/.config/niri/config.kdl` is niri's default config (v26.04) with two
changes: waybar is not started (DMS has its own bar) and `Mod+D` opens the DMS
launcher instead of fuzzel. At the end it includes the files DMS generates in
`~/.config/niri/dms/` and then `everforest.kdl`, so those override the defaults.
`dms/colors.kdl` is left out on purpose, so DMS does not override the Everforest
colours. Put your own changes in `config.kdl`.

If `niri validate` complains after a niri upgrade, compare with the new
default config: `niri --version`, then
`https://github.com/niri-wm/niri/blob/<version>/resources/default-config.kdl`.

DMS is started by its systemd user service (`systemctl --user is-enabled dms`),
so there is no `spawn-at-startup` for it.

`everforest.kdl` also sets `QT_QPA_PLATFORMTHEME=qt6ct` and starts
`everforest-follow`.

If DMS adds a new file to `~/.config/niri/dms/` after an update, add an
`include` line for it in `config.kdl`. Check with `ls ~/.config/niri/dms`.

## 3. Install the GTK theme and icons

```sh
~/.dotfiles/scripts/everforest-install.sh
```

It installs `gtk2-engines-murrine gnome-themes-extra sassc qt6ct
papirus-icon-theme`, builds the Everforest GTK theme in two variants (green
accent, dark soft and light hard) into `~/.themes`, and applies it once.

The installer prints the theme names. If they are not `Everforest-Green-Dark-Soft`
and `Everforest-Green-Light`, add the real names to `everforest.kdl`:

```kdl
environment {
    QT_QPA_PLATFORMTHEME "qt6ct"
    EVERFOREST_DARK_GTK "<dark name>"
    EVERFOREST_LIGHT_GTK "<light name>"
}
```

Note: the upstream GTK theme repo was archived in October 2026. It still works,
but will not get fixes.

If you have real files in `~/.config/gtk-4.0` (`gtk.css`, `gtk-dark.css`,
`assets`), move them away. The helper only replaces symlinks.

## 4. DMS

1. First try the registry theme: **Settings → Theme & Colors**, pick Everforest.
   Use **Soft** in dark mode and **Hard** in light mode to match the terminal.
2. Then switch to the custom theme: **Settings → Theme & Colors → Custom**, and
   choose `~/.config/dms/themes/everforest.json`. DMS saves the choice in its own
   `~/.config/dms/settings.json`, which is not in the dotfiles.
3. Turn **off** matugen app theming for GTK, Qt and Firefox (Settings → Theme &
   Colors → application theming), so it does not override these themes.
   DMS has already written `~/.config/dms/firefox.css`. If Firefox loads it
   (check `chrome/userChrome.css` in your Firefox profile for a link or
   `@import` to it), remove that.
4. Make sure DMS sets the system colour scheme when you toggle light/dark. Check:
   ```sh
   gsettings get org.gnome.desktop.interface color-scheme
   ```
   It should change between `'prefer-dark'` and `'prefer-light'` when you toggle.

## 5. Log out and back in

So niri picks up `QT_QPA_PLATFORMTHEME` and starts `everforest-follow`.

## 6. Firefox (manual)

- Settings → General → Website appearance: **Automatic**.
- Add-ons → Themes: **System theme — auto**, or an Everforest theme from
  addons.mozilla.org that has both light and dark versions.

## 7. Obsidian (manual)

- Settings → Appearance → Themes → Manage: install **Everforest**.
- Base colour scheme: **Adapt to system**.
- Theme options (Style Settings plugin, if the theme exposes it): pick soft for
  dark and hard for light.

## 8. Spotify (Spicetify + Comfy)

Needs the Spotify deb (`spotify-client`), not the snap. Start Spotify once and
log in **before** running `everforest-install.sh`, so its prefs file exists.

The install script:
- downloads Spicetify into `~/.spicetify` and links it to `~/.local/bin`
  (the official installer would append to `~/.zshrc`, which is in this repo),
- makes `/usr/share/spotify` writable (needed for the deb),
- clones Comfy into Spicetify's `Themes` folder and appends the
  `Everforest-dark-soft` and `Everforest-light-hard` schemes from
  `scripts/everforest-spicetify.ini` to Comfy's `color.ini`,
- applies it.

When you switch light/dark, `everforest-follow` runs `spicetify apply`. If
Spotify is open it restarts and playback stops.

After a Spotify update the theme is gone. Run:

```sh
spicetify backup apply
```

If you update Comfy (re-clone it), run `everforest-install.sh` again so the
Everforest schemes are appended again.

## 9. Check it works

Toggle light/dark in DMS and check each of these switches:

- [ ] DMS bar and panels
- [ ] Ghostty, Neovim inside Ghostty, tmux, lazygit
- [ ] Firefox UI and a site that supports dark mode
- [ ] Obsidian
- [ ] A GTK 3 app (for example `gnome-disks` or `gedit`)
- [ ] A GTK 4 app (Nautilus). GTK 4 apps need a restart after a switch.
- [ ] A Qt app. Qt apps also need a restart.
- [ ] Spotify (restarts on switch)

## Troubleshooting

- **Apps do not follow at all**: check which portal is used,
  `ls /usr/share/xdg-desktop-portal/portals/`, and that `xdg-desktop-portal-gtk`
  (or `-gnome`) is installed. Electron apps and Firefox read the colour scheme
  from the portal.
- **GTK/Qt do not switch**: run `everforest-follow --once` in a terminal and read
  its output. Check it is running: `pgrep -af everforest-follow`.
- **Ghostty dark soft looks a bit different from DMS**: the Ghostty dark soft
  theme uses the older Everforest palette (background `#323d43`). The current
  palette uses `#333c43`; update `everforest-dark-soft.ghostty` if it bothers you.

## Changing contrast later

Contrast is fixed per mode. To change it, edit in each place:

- Ghostty: `ghostty/.config/ghostty/config`
- Neovim: `nvim/.config/nvim/init.lua`
- tmux and lazygit: the colour values in their configs
- DMS: the colours in `themes/everforest.json`
- GTK: re-run the installer with another `--tweaks` value and update the names
- Qt: `qt/.config/qt6ct/colors/`
