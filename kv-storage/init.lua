local http = require("http")
local router = require("resty.router")
local json = require("cjson")

local tarantool = require("tarantool")

local config = require("config")
local tarantool_config = config.tarantool

-- Creating a connection to tarantool
local conn = tarantool.connect(tarantool_config.host, tarantool_config.port)

-- Creating namespace
conn:wait_full()
local space = conn.space.data or conn:execute([[box.schema.create_space('data')]])
space:create_index('primary', { type = 'tree', parts = {1, 'string'} })

-- Calls to tarantool API functions
local function get(key)
    local result = space:get(key)
    return result and result[2] or nil
end

local function set(key, value)
    space:replace({key, value})
end

local function delete(key)
    space:delete(key)
end

-- Creating a router and request handlers
local r = router:new()

r:get("/data/:key", function(params)
    local value = get(params.key)
    if not value then
        return {status = 404}
    end

    return {status = 200, body = json.encode(value)}
end)

r:post("/data", function()
    local headers = ngx.req.get_headers()
    local rpc_count = tonumber(headers["X-Rpc-Count"])

    if rpc_count and rpc_count >= config.rpc_limit then
        return {status = 429}
    end

    local data = http.request_body_data()

    set(data.key, data.value)
    return {status = 200}
end)

r:delete("/data/:key", function(params)
    delete(params.key)

    return {status = 200}
end)

http.createServer(function(req, res)
    r:route(req.method, req.url)(req, res)
end):listen(8080)

print("Server started")