# -*- coding: utf-8 -*-
"""
Display wifi information and onclick notifications with more info

@author rixx
"""
import fcntl
import socket
import struct
import subprocess

from time import time


class Py3status:

    # available configuration parameters
    cache_timeout = 60
    ssid_cmd = 'netctl-auto current'
    hide_if_disconnected = False
    notifications = True
    notification_text = '{SSID}: {IP}'
    text = '{SSID}: {IP}'

    def check_wifi(self, i3s_output_list, i3s_config):
        response = {
            'cached_until': time() + self.cache_timeout,
            'full_text': ''
        }

        self.ssid = self._get_ssid()

        if self.ssid:
            self.ip = self._get_ip()
            response['color'] = i3s_config['color_good']
        else:
            if self.hide_if_disconnected:
                return response
            self.ip = ''
            response['color'] = i3s_config['color_bad']

        response['full_text'] = self.text.format(SSID=self.ssid, IP=self.ip)
        return response

    def _get_ssid(self):
        try:
            # ssid = subprocess.check_output(self.ssid_cmd.split()).decode().strip()
            ssid = subprocess.check_output(self.ssid_cmd, shell=True).decode().strip()
        except:
            ssid = ''

        return ssid

    def _get_ip(self):
        procfile = '/proc/net/wireless'
        interface = open(procfile).read().split('\n')[2].split(':')[0]

        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, \
                struct.pack('256s', interface[:15].encode()))[20:24])


    def on_click(self, i3s_output_list, i3s_config, event):
        if self.ssid:
            t = self.notification_text.format(SSID=self.ssid, IP=self.ip)
            subprocess.call(['notify-send', t])



if __name__ == "__main__":
    """
    Test this module by calling it directly.
    """
    from time import sleep
    x = Py3status()
    config = {
        'color_good': '#00FF00',
        'color_bad': '#FF0000',
    }
    while True:
        print(x.check_wifi([], config))
        sleep(1)
