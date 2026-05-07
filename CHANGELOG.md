# Changelog
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
