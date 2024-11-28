# ansible-rust-gameserver
[![ansible lint](https://github.com/compscidr/ansible-rust-gameserver/actions/workflows/check.yml/badge.svg)](https://github.com/compscidr/ansible-rust-gameserver/actions/workflows/check.yml)
[![ansible lint rules](https://img.shields.io/badge/Ansible--lint-rules%20table-blue.svg)](https://ansible.readthedocs.io/projects/lint/rules/)

Enables easy configuration and deployment of rust game servers using
a docker container. The configs and volumes for save games are stored
on the host machine via volumes.

The host machine adds a cron job to control the wipe schedule based
on the configs. The wipe can be weekly, biweekly, or monthly depending
on the config defined. See [roles/rust_gameserver/defaults/main.yml]
for default config values.

The docker image itself is from https://github.com/compscidr/rust-server
which is based on the didstopia image with a few upates.