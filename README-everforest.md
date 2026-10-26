# Everforest on niri + DMS

Everything follows the system appearance. The rule everywhere: **dark uses soft
contrast, light uses hard**. You switch light/dark in DMS and the rest follows.

| Part | How it follows |
| --- | --- |
| DMS (Dux Shell) | Custom theme `dms/.config/DankMaterialShell/themes/everforest.json` |
| niri | `niri/.config/niri/everforest.kdl` (colours work on both modes) |
| GTK 3 / GTK 4 | `everforest-follow` switches `gtk-theme` and the `~/.config/gtk-4.0` links |
| Qt | `everforest-follow` switches the qt6ct colour scheme (Fusion style) |
| Ghostty, Neovim, tmux, lazygit | Already set up, `dark:`/`light:` themes |
| Firefox, Obsidian | Follow the portal `color-scheme`, manual setup below |

## 1. Install packages and stow

Create the niri and DMS config folders first, so stow links files into them
instead of linking the whole folder (otherwise niri and DMS would write their
own files into this repo):

```sh
mkdir -p ~/.config/niri ~/.config/DankMaterialShell ~/.config/qt6ct ~/.local/bin
cd ~/.dotfiles
stow --no-folding dms niri qt everforest
```

If you have no `~/.config/niri/config.kdl` yet, start niri once (it writes the
default config) or copy it from `/usr/share/doc/niri/default-config.kdl`.

## 2. Include the niri colours

Add near the top of `~/.config/niri/config.kdl`:

```kdl
include "everforest.kdl"
```

`everforest.kdl` also sets `QT_QPA_PLATFORMTHEME=qt6ct` and starts
`everforest-follow`. If your `config.kdl` already has a `layout { focus-ring ... }`
block, remove the colour settings there; the later definition wins, so put the
`include` after your own `layout` block if you want to keep both.

Requires niri 25.11 or later for `include`. Check with `niri --version`.

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
2. Then switch to the custom theme. The `config.d/theme.json` override selects it.
   If DMS does not expand `~` in `customThemeFile`, change it to the absolute path
   `/home/<you>/.config/DankMaterialShell/themes/everforest.json`.
3. Turn **off** matugen app theming for GTK, Qt and Firefox (Settings → Theme &
   Colors → application theming), so it does not override these themes.
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

## 8. Check it works

Toggle light/dark in DMS and check each of these switches:

- [ ] DMS bar and panels
- [ ] Ghostty, Neovim inside Ghostty, tmux, lazygit
- [ ] Firefox UI and a site that supports dark mode
- [ ] Obsidian
- [ ] A GTK 3 app (for example `gnome-disks` or `gedit`)
- [ ] A GTK 4 app (Nautilus). GTK 4 apps need a restart after a switch.
- [ ] A Qt app. Qt apps also need a restart.

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
