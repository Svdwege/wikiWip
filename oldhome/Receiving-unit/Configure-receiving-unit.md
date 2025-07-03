The telemetry receiving unit uses a JSON file to configure important parameters such as the IP address of the MQTT broker, the IP address of the database, and the names of the database and tables.

This file must be correctly configured for the system to work properly.

# Configuration file

In figure 1 can you see the contents of the configration file.

On the first start-up of the `telemetry_receiving_unit` container, it will create this at the expected place.
The location where the `appConfig.json` is expected is `/app`.

```JSON
{
    "json_configured": false,
    "mqtt_subscriber": {
        "ip_address": "127.0.0.1",
        "port": 1883,
        "client_id": "not_configured_client",
        "topic": "test/topic",
        "clean_session": true,
        "QoS": 0,
        "keep_alive": 60,
        "username": "username",
        "password": "password"
    },
    "database": {
        "ip_address": "127.0.0.1",
        "port": "3306",
        "name": "test_db",
        "table": "table",
        "username": "username",
        "password": "password"
    }
}
```
_**Figure 1:** the contents template of the `appConfig.json` file_


## Copy file into the Docker container

Docker has a build-in command to copy files. This command can be used to copy the configuration file.
The name of the Docker container `telemetry_receiving_unit`.

With the following command you can copy the `appConfig.json` to `telemetry_receiving_unit`.
```bash
sudo docker cp appConfig.json telemetry_receiving_unit:/app
```

the template for this command is:
```bash
docker cp <sourcefile> <Docker_Container>:/location/
```