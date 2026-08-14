# Rust Gameserver
See: https://github.com/compscidr/ansible-rust-gameserver/blob/main/roles/rust_gameserver/defaults/main.yml

## Usage
add the collection to your meta/requirements.yml:
```
collections:
    - name: compscidr.rust_gameserver
        version: "<insert version here>"
```

Install the collection:
```
ansible-galaxy install -r meta/requirements.yml
```

Use in a playbook:
```
---
- name: Rust Gameserver
    hosts: all
    vars_files:
        - vars/some_vars.yml
    roles:
        - role: compscidr.rust_gameserver.rust_gameserver
```

# Variables
Variable                                | Description
--------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rust_gameserver_startup_args            | Startup args for the rust server
rust_gameserver_identity                | Used to distinguish between different servers locally
rust_gameserver_maxplayers              | Max players allowed to join
rust_gameserver_name                    | The name of the server that shows up in the game browser
rust_gameserver_description             | The description that shows up in the game browser
rust_gameserver_worldsize               | How big the map should be
rust_gameserver_tags                    | Gameserver tags
rust_gameserver_rcon_password           | Password for using the server rcon
rust_gameserver_update_checking         | Whether or not to check for updates on startup
rust_gameserver_rcon_web_port           | Port for rcon web interface 
rust_gameserver_port                    | Port for the game server
rust_gameserver_query_port              | Query port for the game browser
rust_gameserver_rcon_port               | Rcon protocol port
rust_gameserver_app_port                | Rust+ app port
rust_gameserver_oxide_enabled           | Whether or not oxide should be enabled
rust_gameserver_oxide_update_on_boot    | Whether or not oxide should be updated on startup
rust_gameserver_url                     | A url for a website or discord server
rust_gameserver_banner_url              | A url for the background banner for the server browser
rust_gameserver_wipe_day_of_week        | The day of the week the server wipes on (see: https://wiki.facepunch.com/rust/server-wipe-timer)
rust_gameserver_wipe_hour_of_day        | The time of day the server wipes on
rust_gameserver_wipe_minute_of_hour     | The minute of the hour the wipe cron fires (default `0`). Without this, the cron's `minute` field defaults to `*` and would fire every minute of the wipe hour.
rust_gameserver_wipe                    | monthly, biweekly, or weekly
rust_gameserver_timezone                | The timezone string (ex, "America/Los Angeles")
rust_gameserver_wipe_bp                 | Whether or not to wipe blueprints
rust_gameserver_seed                    | Starting seed for the first wipe. If omitted or set to `0`, the wipe script will pick a random seed.
rust_gameserver_healthcheck_disabled    | Set to `true` to override the image's HEALTHCHECK with `["NONE"]`. Useful on hosts where a third-party Docker manager (e.g. UGREEN NAS) ignores the image's `start_period` and kills the container mid-install when the rcon-based health probe fails. Default `false`.
rust_gameserver_manage_wipe_cron        | Whether this role installs the wipe cron + `wipe.sh` (default `true`). Set `false` when an external manager (e.g. rustd.xyz) owns wipes — the cron is removed. See "Management modes" below.
rust_gameserver_overwrite_env           | Whether `rust.env` is re-templated on every run (default `true`). Set `false` to make it bootstrap-only so runtime-managed settings survive deploys. See "Management modes" below.
rust_gameserver_puid                    | Runtime uid the container drops to (default `"1000"`); also owns the per-identity config directories and is used for file ownership
rust_gameserver_pgid                    | Runtime gid (default `"1000"`); also the group on `rust.env` (mode 660) and `seed.env` (mode 664), so the runtime user can read the RCON password while other host users cannot, and an external manager in this group can rewrite both in place — see "Why `rust.env` and `seed.env` are group-writable"

## Management modes

By default this role is authoritative: every run re-templates `rust.env` and
installs the wipe cron. If you manage the server at runtime with an external
tool (for example [rustd.xyz](https://github.com/compscidr/rustd.xyz)), set:

```yaml
rust_gameserver_manage_wipe_cron: false  # removes the cron; your tool owns wipes
rust_gameserver_overwrite_env: false     # rust.env written once at install, never overwritten
```

`seed.env` is always create-only regardless of these flags: the wipe script and
external managers both rotate the seed at runtime, and a deploy must never
revert it (that would change the map on the next restart).

### Why `rust.env` and `seed.env` are group-writable

Both files are bind-mounted into the container as **single files**, and a single-file
bind mount follows the **inode**, not the path. An external manager that rewrites one
the easy way — `sed -i`, or anything that writes a temp file and renames over the
target — only needs write permission on the *directory*, but it replaces the inode.
The mount is then orphaned: the container goes on reading the original file and never
sees another update, while the write keeps reporting success.

That is not hypothetical. It silently cost rustd.xyz every seed change it made — wipes
kept regenerating the same map, because each new seed landed in a file nothing was
reading.

So a manager has to rewrite these two in place (truncate and rewrite the same inode),
which needs write permission on the **file**. Hence:

| file | mode | why |
|--|--|--|
| `rust.env` | `660` | group write for in-place rewrite; never world-readable (`RUST_RCON_PASSWORD`) |
| `seed.env` | `664` | same, and not secret, so it keeps the world-read bit |

Group write is not an escalation: the identity directory is already group-writable
(`rust_gameserver_identity_dir_mode`, default `2775`), so a manager in the runtime group
could already replace these files. This only lets it do the *correct* thing instead.

Existing installs are retrofitted — the mode is enforced by a separate attributes-only
task, because `force: false` skips mode and group on a file that already exists.