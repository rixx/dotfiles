# dotfiles

Config files for my general environment. Pretty up to date usually. In use on both user and server systems.

## If you're not me

Things you might want to look at:

- The vim config is pretty neat. Nothing minimal, but I try to only include plugins that actually help my workflows.
- I'm not shell coder at all, but my zsh config is really pretty alright and modular.
- The mutt and tmux configs are alright, but nothing special.
- Some of the tool configs can get you started easier, maybe: dunst, i3 and rofi, in particular.
- I also try to document my firefox extensions and their settings.
- There are a couple of small helper scripts in `bin`.

## New PC who dis

1. Install the packages listed in ``packages-to-install``.
2. Run ``./install``.
3. Install crontabs from ``./crontab``

### If on a Desktop system

1. Perform Firefox plugin config steps.
2. If on a Desktop system, install ``X/override.conf`` for login handling.
3. If on a Desktop system on a ThinkPad, install ``X/40-thinkpad-keyboard.conf``.
4. Download [this obsidian fork](https://github.com/rixx/obsidian-local-images), `npm install && npm run build`, ``cp -r
   build ~/doc/wiki/.obsidian/plugins/obsidian-local-images``, be sad.

## Troubleshooting

### All GTK apps take forever to start

```
systemctl --user mask xdg-desktop-portal-gtk.service 
```
