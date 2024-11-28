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
rust_gameserver_wipe                    | monthly, biweekly, or weekly
rust_gameserver_timezone                | The timezone string (ex, "America/Los Angeles")
rust_gameserver_wipe_bp                 | Whether or not to wipe blueprints
rust_gameserver_seed                    | Starting seed for the first wipe. The wipe script will pick random