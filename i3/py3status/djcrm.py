"""
@author rixx
"""

import json
import subprocess
from datetime import datetime
from functools import cached_property
from time import time

import requests


class Py3status:
    cache_timeout = 60
    token = ""
    url = ""
    match_string = ""

    @cached_property
    def _base_url(self):
        if self.url.startswith("https://"):
            url = self.url[len("https://") :]
        return url.rstrip("/")

    @cached_property
    def _api_url(self):
        return f"https://{self._base_url}/api/invoices/?format=json&ordering=-nr"

    def check_invoices(self, i3s_output_list, i3s_config):
        response = {
            "cached_until": time() + self.cache_timeout,
            "full_text": "",
            "color": i3s_config["color_good"],
        }

        try:
            rsp = requests.get(
                self._api_url,
                headers={"Authorization": "Token {self.token}".format(self=self)},
                verify=False,
            )
            invoices = rsp.json()["results"]
        except Exception:
            response["color"] = i3s_config["color_bad"]
            response["full_text"] = "€?"
            return response

        invoice_count = 0
        money_sum = 0
        current_month = datetime.now().strftime("%Y-%m")

        for invoice in invoices:
            if current_month not in invoice["date"]:
                # Invoices are ordered by date, so we can stop here
                break

            if self.match_string:
                if not any(
                    self.match_string in line["title"] for line in invoice["lines"]
                ):
                    continue

            if invoice["status"] == "draft":
                continue

            invoice_count += len(invoice["lines"])
            money_sum += sum((float(line["total_net"]) for line in invoice["lines"]), 0)

        money_sum = round(money_sum, 2)
        self._full_text = f"€{money_sum:.2f} ({invoice_count})"
        # response["full_text"] = self._full_text
        response["full_text"] = "€"
        return response

    def on_click(self, i3s_output_list, i3s_config, event):
        # show full text on left click
        if event["button"] == 1:
            subprocess.call(
                [
                    "notify-send",
                    "-t",
                    "5000",
                    "-i",
                    "dialog-information",
                    "Invoices",
                    self._full_text,
                ]
            )
        else:
            # only non-left click events should open the browser
            subprocess.call(
                [
                    "xdg-open",
                    f"https://{self._base_url}/admin/crmbase/invoice/stats/?costcenter=1",
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
        print(x.check_invoices([], config))
        sleep(1)
