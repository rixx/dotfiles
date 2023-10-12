"""
Display how many of your followed Twitch accounts are currently streaming or not.
Thanks go to Alex Caswell horatioesf@virginmedia.com for his version with different scope on the v4 API.

Configuration parameters:
    cache_timeout: how often we refresh this module in seconds
        (default 60)
    client_id: Your client id. Create your own key at https://dev.twitch.tv
        (default None)
    client_secret: Your client id. Create your own key at https://dev.twitch.tv
        (default None)
    format: Display format when online
        (default "{live_count} is live!")

Format placeholders:
    {display_name} streamer display name, eg Ultrabug

Client ID:
    Example settings when creating your app at https://dev.twitch.tv

    Name: <your_name>_py3status
    OAuth Redirect URI: https://localhost
    Application Category: Application Integration

@author Tobias Kunze r@rixx.de
@license BSD
"""
import subprocess


class Py3status:
    # available configuration parameters
    cache_timeout = 60
    client_id = None
    client_secret = None
    bearer = None
    user_id = None
    format = "{live_count}"

    def post_config_hook(self):
        for config_name in ["client_id", "client_secret", "bearer"]:
            if not getattr(self, config_name, None):
                raise Exception("Missing config {}".format(config_name))

        self.headers = {
            "Client-ID": self.client_id,
            "Authorization": f"Bearer {self.bearer}",
        }
        self.stream_url = "https://api.twitch.tv/helix/streams/"
        self.user_url = (
            f"https://api.twitch.tv/helix/users/follows?from_id={self.user_id}"
        )
        self.users = self._get_users()
        self.streams = []

    def _get_twitch_data(self, url):
        try:
            response = self.py3.request(url, headers=self.headers)
        except self.py3.RequestException:
            return {}
        data = response.json()
        if not data:
            data = vars(response)
            error = data.get("_error_message")
            if error:
                self.py3.error("{} {}".format(error, data["_status_code"]))
        return data

    def _get_users(self):
        data = self._get_twitch_data(self.user_url)
        users = [u["to_id"] for u in data.get("data")]
        while data["pagination"].get("cursor"):
            data = self._get_twitch_data(
                self.user_url + f"&after={data['pagination']['cursor']}"
            )
            users += [u["to_id"] for u in data.get("data")]
            if len(users) >= 100:
                break
        return users[:99]

    def twitch(self):
        url = self.stream_url + "?" + "&".join([f"user_id={u}" for u in self.users])
        streams = self._get_twitch_data(url).get("data")
        if not streams:
            self.streams = []
        else:
            self.streams = [
                {
                    "name": s["user_name"],
                    "game": s["game_name"],
                    "viewers": s["viewer_count"],
                }
                for s in streams
            ]
        if self.streams:
            return {
                # "color": self.py3.COLOR_GOOD,
                "cached_until": self.py3.time_in(self.cache_timeout),
                "full_text": self.py3.safe_format(
                    self.format, {"live_count": len(self.streams)}
                ),
            }
        return {
            "cached_until": self.py3.time_in(self.cache_timeout),
            "full_text": "",
        }

    def on_click(self, event):
        if event["button"] == 2:
            subprocess.call(["xdg-open", "https://twitch.tv/directory/Following"])
        if event["button"] == 1:
            notification_message = f"{len(self.streams)} streams running!\n\n"
            notification_message += "\n".join(
                [f"{s['name']} with {s['game']} ({s['viewers']})" for s in self.streams]
            )
            subprocess.call(["notify-send", notification_message])


if __name__ == "__main__":
    """
    Run module in test mode.
    """
    from py3status.module_test import module_test

    config = {
        "client_id": open("secrets/twitch_clientid").read().strip(),
        "client_secret": open("secrets/twitch_clientsecret").read().strip(),
        "bearer": open("secrets/twitch_bearer").read().strip(),
        "user_id": 419412255,
        "format": "{live_count}",
    }

    module_test(Py3status, config=config)
