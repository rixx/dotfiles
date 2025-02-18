# -*- coding: utf-8 -*-
"""
@author rixx
"""
import subprocess
from time import time

import bs4
import requests


class Py3status:
    # available configuration parameters
    cache_timeout = 60
    login_url = ""
    url = ""
    user = ""
    password = ""

    def check_rt(self, i3s_output_list, i3s_config):
        response = {"full_text": ""}

        try:
            client = requests.session()
            client.get(self.login_url, verify=False)

            login_data = {"user": self.user, "pass": self.password}

            r = client.post(self.login_url, data=login_data)
            r = client.get(self.url + "")

            soup = bs4.BeautifulSoup(r.content, "html.parser")
            text = soup.find(id="header").get_text()
            num = text[6 : text.find("ticket")].strip()

            if num == "0":
                response["color"] = i3s_config["color_good"]
            else:
                response["color"] = i3s_config["color_bad"]
        except Exception:
            num = ""
            response["color"] = i3s_config["color_bad"]

        response["full_text"] = "🎟️{}".format(num)
        return response

    def on_click(self, i3s_output_list, i3s_config, event):
        subprocess.call(["xdg-open", self.url])


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
