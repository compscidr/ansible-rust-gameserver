# Changelog
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
