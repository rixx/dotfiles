"""
Use ~/.config/dotfiles/bin/focus start|stop|break, read status from /tmp/focus
"""
from pathlib import Path


class Py3status:
    cache_timeout = 300
    client_id = None
    client_secret = None
    auth_redirect = None
    username = None
    password = None
    format = "{title}"

    def _get_status(self):
        if Path("/tmp/focus").exists():
            try:
                return bool(int(open("/tmp/focus").read().strip()))
            except Exception:
                pass

    def focus(self):
        self.status = self._get_status()
        return {
            "full_text": "🔥" if self.status else "🌱",
            "cached_until": self.py3.time_in(self.cache_timeout),
        }

    def on_click(self, event):
        if not self.status:
            self.py3.command_run("focus start")
        else:
            self.py3.command_run("focus stop")
