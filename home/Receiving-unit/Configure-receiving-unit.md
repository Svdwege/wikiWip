The telemetry receiving unit uses a JSON file to configure important parameters such as the IP address of the MQTT broker, the IP address of the database, and the names of the database and tables.

This file must be correctly configured for the system to work properly.

# Configuration file

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
