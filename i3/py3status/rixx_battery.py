from py3status.modules.battery_level import Py3status as BatteryLevel


class Py3status(BatteryLevel):
    """
    This module is a fork of battery_level module to
    - add icons to notifications
    - set a title on notifications

    (sadly we can't just override a method, so we have to copy-paste both methods
    that can send notifications)
    """

    def on_click(self, event):
        """
        Display a notification following the specified format
        """
        if not self.notification:
            return

        if self.charging:
            format = self.format_notify_charging
        else:
            format = self.format_notify_discharging

        message = self.py3.safe_format(
            format,
            dict(
                ascii_bar=self.ascii_bar,
                icon=self.icon,
                percent=self.percent_charged,
                time_remaining=self.time_remaining,
            ),
        )

        if message:
            self._notify_user(message, "info")

    def _set_bar_color(self):
        notify_msg = None
        if self.charging:
            self.response["color"] = self.py3.COLOR_CHARGING or "#FCE94F"
            battery_status = "charging"
        elif self.percent_charged < self.threshold_bad:
            self.response["color"] = self.py3.COLOR_BAD
            battery_status = "bad"
            notify_msg = {
                "msg": "Battery level is critically low ({}%)",
                "level": "error",
            }
        elif self.percent_charged < self.threshold_degraded:
            self.response["color"] = self.py3.COLOR_DEGRADED
            battery_status = "degraded"
            notify_msg = {
                "msg": "Battery level is running low ({}%)",
                "level": "warning",
            }
        elif self.percent_charged >= self.threshold_full:
            self.response["color"] = self.py3.COLOR_GOOD
            battery_status = "full"
        else:
            battery_status = "good"

        if (
            notify_msg
            and self.notify_low_level
            and self.last_known_status != battery_status
        ):
            self._notify_user(
                notify_msg["msg"].format(self.percent_charged), notify_msg["level"]
            )

        self.last_known_status = battery_status

    def _notify_user(self, message, level):
        kwargs = {}
        if level == "warning":
            kwargs["icon"] = "battery-caution"
        elif level == "critical":
            kwargs["icon"] = "battery-empty"
        elif self.percent_charged > 80:
            kwargs["icon"] = "battery-full"
        elif self.percent_charged > 60:
            kwargs["icon"] = "battery-good"
        elif self.percent_charged > 40:
            kwargs["icon"] = "battery-low"
        else:
            kwargs["icon"] = "battery-caution"
        kwargs["title"] = "Battery"
        self.py3.notify_user(message, level, **kwargs)
