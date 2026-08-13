# Changelog
## 0.4.0
* **BREAKING — one tree per server, replacing 0.3.0 (do not deploy 0.3.0: its nested install mount crash-loops the container).** Each server now lives entirely under `/etc/rust/install/<identity>` (var `rust_gameserver_install_dir`), bind-mounted at the container's `/steamcmd/rust`. The game's own layout puts the save/identity dir at `server/<identity>` inside it (var `rust_gameserver_data_dir`); `oxide/` and `RustDedicated_Data/` sit at the tree's root; `rust.env`/`seed.env`/`wipe.sh` live in the identity dir. Root-level game files — vanilla `world.rendermap` output that rustd.xyz fetches over SSH — are now host-visible. Never point two containers at one install dir: concurrent steamcmd updates conflict
* **Migration from the `/etc/rust/server/<identity>` layout** (per server, before deploying):
  ```
  docker stop rust-<identity>
  mkdir -p /etc/rust/install/<identity>/server
  mv /etc/rust/server/<identity> /etc/rust/install/<identity>/server/<identity>
  mv /etc/rust/install/<identity>/server/<identity>/oxide /etc/rust/install/<identity>/oxide
  mv /etc/rust/install/<identity>/server/<identity>/RustDedicated_Data /etc/rust/install/<identity>/RustDedicated_Data
  rm -rf /etc/rust/install/<identity>/server/<identity>/install   # 0.3.0 orphan, if present
  ```
  then deploy (the container is recreated; steamcmd downloads the game into the tree on first boot, ~8 GB). Point external managers (rustd.xyz) at the new paths: data path `/etc/rust/install/<identity>/server/<identity>`, map render path `/etc/rust/install/<identity>`

## 0.3.0
* Mount the game install root on the host (`/etc/rust/server/<identity>/install`) so files the game writes to its root — e.g. vanilla `world.rendermap` output, fetched over SSH by rustd.xyz — are host-visible. First boot after adopting the mount re-downloads the game into it; saves/plugins/env mounts are unchanged

## 0.2.0
* New `rust_gameserver_manager_users` (default `[]`): host users an external manager (e.g. rustd.xyz) connects as, appended to the container's runtime group so they can write inside the identity directory. Deliberately group membership rather than a sudo grant — such a manager's filesystem work is confined to that one directory tree and it drives the server lifecycle over RCON, so root is never required
* New `rust_gameserver_identity_dir_mode` (default `'0755'`, unchanged behaviour): set `'2775'` alongside `rust_gameserver_manager_users`. The group-write bit lets the manager create snapshots and delete map/save files; **SETGID is load-bearing** — `sed -i` on `seed.env` replaces the file rather than editing it, and without setgid the replacement lands in the manager's own group, at which point the container can no longer read its own seed
* `/etc/rust/server/<identity>` is now managed explicitly instead of appearing as a side effect of creating its children, which is what makes the mode above meaningful

## 0.1.1
* New `rust_gameserver_puid` / `rust_gameserver_pgid` vars (default `"1000"`): configure the container runtime uid/gid in one place — used for the container `PUID`/`PGID` env, per-identity directory ownership, and `rust.env` group
* Per-identity config directories (`oxide/`, `oxide/plugins/`, `cfg/`, `RustDedicated_Data/`, `Managed/`) are now owned by the runtime user instead of root — Oxide and the server run as that uid and need to create files there (root-owned dirs silently broke plugin data writes and config rewrites)
* `rust.env` permissions (640, root:pgid) are now enforced even on existing installs (the `force: false` bootstrap path previously skipped attribute changes)

## 0.1.0
* `seed.env` is now create-only (never overwritten by deploys) for all users — `wipe.sh` rotates the seed at runtime, so re-templating it on deploy could silently change the map on the next restart
* New flag `rust_gameserver_manage_wipe_cron` (default `true`): set `false` when an external manager (e.g. rustd.xyz) owns wipes — the wipe cron is removed and `wipe.sh` is not installed
* New flag `rust_gameserver_overwrite_env` (default `true`): set `false` to make `rust.env` bootstrap-only so runtime-managed settings survive deploys

## 0.0.7
* Fix wipe cron firing every minute of the wipe hour (the `minute` field defaulted to `*`); now defaults to `0` and is configurable via `rust_gameserver_wipe_minute_of_hour`
* Added `rust_gameserver_healthcheck_disabled` to override the image's HEALTHCHECK on hosts whose Docker manager ignores `start_period` and kills the container mid-install

## 0.0.6
* Fixed paths so multiple server configs don't all show up in each others containers
* Fixed paths for plugins
* Separate oxide plugins / config and dll plugins if multiple servers
* Updated documentation
* Set oxide enabled by default
* First release
