# docker

`daemon.json` goes to `/etc/docker/daemon.json` (installed by `just` in the dotfiles root).

Why: WIFIonICE (DB train wifi) hands out 172.18.0.0/16. Docker's default pools put the default bridge on 172.17.0.0/16 and the first user-defined network on 172.18.0.0/16, so its route shadows the wifi and the connection dies. This config moves Docker to 10.213.0.0/16: the default bridge gets 10.213.0.0/24, new networks get /24s from 10.213.16.0/20 (16 networks).

Existing networks keep their old subnet after a config change. Remove and recreate them (`docker compose down`, `docker network rm NAME`), then restart the daemon.
