"""
Display one (1) TickTick task that is (over)due today.
Left-click to complete, right-click to cycle to next task.

The odd name is because we're importing the ticktick library, so this file
cannot be called ticktick. Joy.

Configuration parameters:
    client_id: follow https://lazeroffmichael.github.io/ticktick-py/#get-started for auth
    client_secret: follow https://lazeroffmichael.github.io/ticktick-py/#get-started for auth
    username: your email address
    password: your ticktick password
    auth_redirect: whatever you configured in your TickTick application

Format placeholders:
    {title} Task title
    {tags} Task tags

@author Tobias Kunze r@rixx.de
@license BSD
"""
import datetime as dt

from ticktick.api import TickTickClient  # Main Interface
from ticktick.helpers.time_methods import convert_date_to_tick_tick_format
from ticktick.oauth2 import OAuth2  # OAuth2 Manager

CACHE_PATH = "/home/rixx/.cache/.ticktick-oauth-token"


class Py3status:
    cache_timeout = 300
    client_id = None
    client_secret = None
    auth_redirect = None
    username = None
    password = None
    format = "{title}"

    def post_config_hook(self):
        for config_name in [
            "client_id",
            "client_secret",
            "auth_redirect",
            "username",
            "password",
        ]:
            if not getattr(self, config_name, None):
                raise Exception("required param {} not found".format(config_name))

        auth_client = OAuth2(
            client_id=self.client_id,
            client_secret=self.client_secret,
            redirect_uri=self.auth_redirect,
            cache_path=CACHE_PATH,
        )

        self.client = TickTickClient(self.username, self.password, auth_client)
        self.tag_lookup = {tag["name"]: tag for tag in self.client.state["tags"]}
        self.tag_lookup[None] = {"sortOrder": 999999}
        self.tasks = []
        self.current_index = 0
        self.current_task = 0

    def _fetch_tasks(self):
        today = dt.datetime.today()
        today.replace(hour=23, minute=59)
        yesterday = today - dt.timedelta(days=1)
        self.end_of_day = convert_date_to_tick_tick_format(today, "Europe/Berlin")
        self.start_of_day = convert_date_to_tick_tick_format(yesterday, "Europe/Berlin")
        # don't you love that we can run string compares?
        tasks = []
        for task in self.client.state["tasks"]:
            if task.get("dueDate") and task["dueDate"] <= self.end_of_day:
                tags = task.get("tags")
                tag = tags[0] if tags else None
                task["main_tag"] = tag
                tasks.append(task)

        tasks.sort(
            key=lambda t: (self.tag_lookup[t["main_tag"]]["sortOrder"], t["sortOrder"])
        )
        return tasks

    def ticktick3(self):
        color = None
        self.tasks = self._fetch_tasks()
        if not self.tasks:
            return
        if self.current_index - 1 > len(self.tasks):
            self.current_index = 0
        self.current_task = self.tasks[self.current_index]
        tags = ", ".join([f"#{tag}" for tag in self.current_task.get("tags", [])])
        color = (
            self.py3.COLOR_GOOD
            if self.current_task["dueDate"] >= self.start_of_day
            else self.py3.COLOR_BAD
        )
        return {
            "color": color,
            "full_text": self.py3.safe_format(
                self.format, {"title": self.current_task["title"], "tags": tags}
            ),
        }

    def on_click(self, event):
        if event["button"] == 1:
            # left click marks as done
            if not self.current_task:
                return
            self.client.task.complete(self.current_task)
        elif event["button"] == 2:
            # middle click reloads
            self.tasks = self._fetch_tasks()
        elif event["button"] == 3:
            # right click (3) cycles
            self.current_index += 1
            self.current_index = self.current_index % (len(self.tasks) - 1)


if __name__ == "__main__":
    """This fixes the auth"""
    CLIENT_ID = (
        open("/home/rixx/.config/dotfiles/i3/py3status/secrets/ticktick_clientid")
        .read()
        .strip()
    )
    CLIENT_SECRET = (
        open("/home/rixx/.config/dotfiles/i3/py3status/secrets/ticktick_clientsecret")
        .read()
        .strip()
    )
    USERNAME = (
        open("/home/rixx/.config/dotfiles/i3/py3status/secrets/ticktick_username")
        .read()
        .strip()
    )
    PASSWORD = (
        open("/home/rixx/.config/dotfiles/i3/py3status/secrets/ticktick_password")
        .read()
        .strip()
    )
    AUTH_REDIRECT = "http://127.0.0.1:8000"
    auth_client = OAuth2(
        client_id=CLIENT_ID,
        client_secret=CLIENT_SECRET,
        redirect_uri=AUTH_REDIRECT,
        cache_path=CACHE_PATH,
    )
    client = TickTickClient(USERNAME, PASSWORD, auth_client)

    from py3status.module_test import module_test

    config = {
        "client_secret": CLIENT_SECRET,
        "client_id": CLIENT_ID,
        "auth_redirect": AUTH_REDIRECT,
        "username": USERNAME,
        "password": PASSWORD,
        "format": "{title} {tags}",
    }
    module_test(Py3status, config=config)
