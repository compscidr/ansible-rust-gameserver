# ansible-rust-gameserver
[![Static Badge](https://img.shields.io/badge/Ansible_galaxy-Download-blue)](https://galaxy.ansible.com/ui/repo/published/compscidr/rust_gameserver/)
[![ansible lint](https://github.com/compscidr/ansible-rust-gameserver/actions/workflows/check.yml/badge.svg)](https://github.com/compscidr/ansible-rust-gameserver/actions/workflows/check.yml)
[![ansible lint rules](https://img.shields.io/badge/Ansible--lint-rules%20table-blue.svg)](https://ansible.readthedocs.io/projects/lint/rules/)

Enables easy configuration and deployment of rust game servers using
a docker container. The configs and volumes for save games are stored
on the host machine via volumes.

The host machine adds a cron job to control the wipe schedule based
on the configs. The wipe can be weekly, biweekly, or monthly depending
on the config defined. See [roles/rust_gameserver/defaults/main.yml](roles/rust_gameserver/defaults/main.yml)
for default config values.

The docker image itself is from https://github.com/compscidr/rust-server
which is based on the didstopia image with a few upates.

## Oxide Plugins
Since there may be multiple servers running on a machine, you can copy plugins 
to `/etc/rust/server/{{ rust_gameserver_identity }}/oxide/plugins` on the host
machine.

Oxide config can be copied to `/etc/rust/server/{{ rust_gameserver_identity }}/oxide/`
You may want to do this if you are using oxide plugins, but want to set your config
to non-modified if you want to show up in the community servers list (note, you
should only do this if your plugins don't modify game behavior)

## Dll Plugins
Plugins like [rust::io](http://playrust.io/manual/#!index.md) should be copied
to `/etc/rust/server/{{ rust_gameserver_identity }}/RustDedicated_Data/Managed`.
