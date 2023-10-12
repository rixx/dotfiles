# -*- coding: utf-8 -*-
"""
@author rixx
"""
import json
import subprocess
from time import time

import requests


class Py3status:
    # available configuration parameters
    # url = 'pretix.instance/api/v1/organizers/{organizer_slug}/events/{event_slug}/quotas/{pk}/availability/'
    cache_timeout = 60
    url = ""
    instance = ""
    organizer = ""
    event = ""
    quota = ""
    token = ""
    good_threshold = 50

    def check_tickets(self, i3s_output_list, i3s_config):
        response = {"cached_until": time() + self.cache_timeout, "full_text": ""}

        try:
            url = "https://{self.instance}/api/v1/organizers/{self.organizer}/events/{self.event}/quotas/{self.quota}/availability/".format(
                self=self
            )
            rsp = requests.get(
                url,
                headers={"Authorization": "Token {self.token}".format(self=self)},
                verify=False,
            )

            num = max(0, json.loads(rsp.content.decode()).get("available_number", 0))

            if num >= self.good_threshold:
                response["color"] = i3s_config["color_good"]
            else:
                response["color"] = i3s_config["color_bad"]
        except Exception:
            num = ""
            response["color"] = i3s_config["color_bad"]

        response["full_text"] = " {}".format(num)
        return response

    def on_click(self, i3s_output_list, i3s_config, event):
        subprocess.call(
            [
                "xdg-open",
                "https://{self.instance}/control/event/{self.organizer}/{self.event}/".format(
                    self=self
                ),
            ]
        )


if __name__ == "__main__":
    """
    Test this module by calling it directly.
    """
    from time import sleep

    x = Py3status()
    config = {
        "color_good": "#00FF00",
        "color_bad": "#FF0000",
    }
    while True:
        print(x.check_tickets([], config))
        sleep(1)
