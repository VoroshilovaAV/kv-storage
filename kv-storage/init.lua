local http = require("http")
local router = require("resty.router")
local json = require("cjson")

local tarantool = require("tarantool")

local config = require("config")
local tarantool_config = config.tarantool

local r = router:new()

-- GET request handler
r:get("/data/:key", function(params)
    local value = storage.get(params.key)
    if not value then
        return {status = 404}
    end

    return {status = 200, body = json.encode(value)}
end)

-- POST request handler
r:post("/data", function()
    local headers = ngx.req.get_headers()
    local rpc_count = tonumber(headers["X-Rpc-Count"])

    if rpc_count and rpc_count >= config.rpc_limit then
        return {status = 429}
    end

    local data = http.request_body_data()

    storage.set(data.key, data.value)
    return {status = 200}
end)

-- DELETE request handler
r:delete("/data/:key", function(params)
    storage.delete(params.key)

    return {status = 200}
end)

http.createServer(function(req, res)
    r:route(req.method, req.url)(req, res)
end):listen(8080)

print("Server started")