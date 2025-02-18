# -*- coding: utf-8 -*-
"""
Display Home Assistant entity states in i3bar
@author Tobias Kunze
"""

import json
import subprocess
from time import time
import requests


class Py3status:
    # available configuration parameters
    cache_timeout = 60
    # Home Assistant instance URL (e.g. "http://homeassistant.local:8123")
    instance = ""
    token = ""  # Long-lived access token
    entity_id = ""  # Entity ID to monitor (e.g. "sensor.temperature")
    format = " {state}"  # Default display format
    format_good = None  # Optional format override for good state
    format_degraded = None  # Optional format override for degraded state
    format_bad = None  # Optional format override for bad state
    prefix = ""  # Optional prefix before the state
    suffix = ""  # Optional suffix after the state
    threshold_bad = None  # Value or list of values that indicate a bad state
    threshold_good = None  # Value or list of values that indicate a good state
    threshold_degraded = None  # Value or list of values that indicate a degraded state
    numeric_thresholds = False  # Set to True to compare numeric values
    ssid = None  # Optional SSID to check against
    device = None  # Optional network device to check SSID on

    def post_config_hook(self):
        """
        Normalize threshold values after config is loaded.
        Convert single values to tuples and cast to float if numeric_thresholds is True.
        """
        for threshold_name in ["threshold_bad", "threshold_good", "threshold_degraded"]:
            threshold = getattr(self, threshold_name)
            if threshold is not None:
                # Convert to float if numeric_thresholds is True
                if self.numeric_thresholds:
                    try:
                        threshold = tuple(
                            float(t) if isinstance(t, str) else t for t in threshold
                        )
                    except ValueError:
                        # If conversion fails, keep original values
                        pass

                # Store normalized threshold
                setattr(self, threshold_name, threshold)

    def _check_threshold(self, state, threshold):
        """Compare state against threshold value or list"""
        if threshold is None:
            return False

        if isinstance(threshold, (list, tuple)):
            if self.numeric_thresholds:
                try:
                    state_num = float(state)
                    return threshold[0] <= state_num <= threshold[1]
                except ValueError:
                    return state in threshold
            return state in threshold

        if self.numeric_thresholds:
            try:
                state_num = float(state)
                threshold_num = (
                    float(threshold) if isinstance(threshold, str) else threshold
                )
                return state_num == threshold_num
            except ValueError:
                return state == threshold

        return state == threshold

    def _get_current_ssid(self):
        """Get current SSID using netctl"""
        try:
            output = subprocess.check_output(
                ["sudo", "netctl-auto", "list"], stderr=subprocess.STDOUT
            ).decode()
            for line in output.split("\n"):
                if line.startswith("*"):  # Active profile is marked with *
                    return line.strip("* ")
        except (subprocess.CalledProcessError, IndexError):
            return None
        return None

    def _get_state(self):
        """Query Home Assistant API for entity state"""
        if not all([self.instance, self.token, self.entity_id]):
            return None

        url = f"{self.instance}/api/states/{self.entity_id}"
        headers = {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json",
        }

        try:
            response = requests.get(url, headers=headers, timeout=10)
            response.raise_for_status()
            data = response.json()
            return data.get("state")
        except Exception:
            return None

    def homeassistant(self, i3s_output_list, i3s_config):
        """Return response dict for py3status"""
        response = {"cached_until": time() + self.cache_timeout, "full_text": ""}

        # Check if we should be active based on SSID
        if self.ssid and self.device:
            current_ssid = self._get_current_ssid()
            if current_ssid != self.ssid:
                response["full_text"] = ""  # Hide when not on specified network
                return response

        state = self._get_state()

        if state is None:
            response["full_text"] = " ?"
            response["color"] = i3s_config["color_bad"]
        else:
            # Determine state and format to use
            format_to_use = self.format
            response["color"] = i3s_config["color_good"]

            if self._check_threshold(state, self.threshold_bad):
                response["color"] = i3s_config["color_bad"]
                if self.format_bad:
                    format_to_use = self.format_bad
            elif self._check_threshold(state, self.threshold_degraded):
                response["color"] = i3s_config["color_degraded"]
                if self.format_degraded:
                    format_to_use = self.format_degraded
            elif self._check_threshold(state, self.threshold_good):
                if self.format_good:
                    format_to_use = self.format_good

            response["full_text"] = format_to_use.format(
                state=state, prefix=self.prefix, suffix=self.suffix
            )

        return response

    def on_click(self, i3s_output_list, i3s_config, event):
        """Open Home Assistant dashboard on click"""
        if self.instance:
            subprocess.call(["xdg-open", self.instance])


if __name__ == "__main__":
    """
    Test this module by calling it directly.
    """
    from time import sleep

    x = Py3status()
    config = {
        "color_good": "#00FF00",
        "color_bad": "#FF0000",
        "color_degraded": "#FFFF00",
    }

    # Test configuration
    x.instance = "http://homeassistant.local:8123"
    x.token = "your_long_lived_access_token"
    x.entity_id = "sensor.temperature"

    while True:
        print(x.homeassistant([], config))
        sleep(1)
