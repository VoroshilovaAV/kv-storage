local http_server = require('http.server')
local http_router = require('http.router')
local my_handlers = require('app.handlers')

local conf = require('app.config')

local server = http_server.new(nil, conf.server_port)

local router = http_router.new()
router:route({ path = '/kv', method = 'GET' }, my_handlers.get_handler)
router:route({ path = '/kv', method = 'POST' }, my_handlers.post_handler)
router:route({ path = '/kv', method = 'DELETE' }, my_handlers.delete_handler)

server:set_router(router)

server:start()