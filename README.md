# kv-storage
The application is a key value storage based on Tarantool

#### Features
The application can accept GET, POST and DELETE requests. If rpc_limit is exceeded, code 429 is returned. You can change the rpc_limit value in the config.lua configuration file.

#### Documentation
Can be found at https://www.tarantool.io/ru/doc/latest/
#### Tech
- Tarantool
- Lua 
- The http, resty.router and cjson lib

#### Testing and usage
To start the server, run the command:
``` lua
tarantool kv-storage/init.lua
```

To retrieve data for a key, make a GET request. For example, to retrieve data for the key "test", send a GET request to http://localhost:8080/data/test.

To insert new data, make a POST request. For example, to add data with the key "test" and the value "value," send a POST request to http://localhost:8080/data with the body of the request in JSON format:

```json
{
    "key": "test",
    "value": "value"
}
```
To delete data by a key, make a DELETE request. For example, to delete data by the "test" key, send a DELETE request to http://localhost:8080/data/test.
