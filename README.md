# dotfiles

Config files for my general environment:

- `X/xinitrc` for general X startup. There are a couple of very specific rules/services in there, too.
- `calendar` contains the config files to run my calendar website as a separate window on the fly with electron
- `dunst` is a notification daemon
- `firefox` contains the `userChrome.css` with my slightly absurd modifications to the Firefox UI
- `git/gitconfig` contains my user-local git config, including my aliases
- `i3` is my window manager, `py3status` is the modular status bar
- `mutt` contains a sprawling neomutt configuration. What is my life.
- `notmuch` indexes and searches mailboxes
- `pass` is a password manager
- `picom` is a compositor that regularly crashes to hilarious effect
- `ranger` is a file browser
- `rofi` is a, hm, well. It can do a lot, but I use it as a program starter and window switcher for the most part. And
  as emoji picker and password lookup interface, naturally. Do one job and do it well, after all.
- `scripts` contains a small handful of useful scripts. Newer ones are [here](https://github.com/rixx/tools)
- `tmux` is a terminal multiplexer, which is incredibly useless to know if you don't know tmux already
- `urxvt` was my terminal for a while, and I keep its `Xresources` config (colour and styles) just in case I'll use it
  again, because it's painful to build
- `vim`, look, my vimrc is not *that* bad, but I do believe in customisation. It's commented, though, so it might
  actually be helpful for others.
- `zsh` contains a bunch of helpers for zsh, for the most part pilfered from oh-my-zsh and similar script collections
