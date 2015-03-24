
local proto = require "proto"
local sproto = require "sproto"
local bit  = require "bit"

local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))


MessageManager = class("MessageManager")

self = MessageManager

function MessageManager:init()


end

local function extract( n, i, j )
    local rNum = bit.rshift(n,i)
    local num = 1
    local sub = bit.band(rNum,bit.lshift(num,j)-1)

    return bit.tobit(sub)
end


function MessageManager:pack_package(key,value,session)

	local str = request("get",{ what = "hello" },session)
	local size = #str
    return string.char(extract(size,8,8)) .. string.char(extract(size,0,8)) .. str
end

function MessageManager:unpack_package(text)
    local size = #text
    if size < 2 then
        return nil, text
    end
    local s = text:byte(1) * 256 + text:byte(2)
    if size < s+2 then
        return nil, text
    end

    return text:sub(3,2+s), text:sub(3+s)
end
function MessageManager:print_package(text)
    self:print_package_(host:dispatch(text))
end

function MessageManager:print_package_(t, ...)
    if t == "REQUEST" then
        self:print_request(...)
    else
        assert(t == "RESPONSE")
        self:print_response(...)
    end
end

function MessageManager:print_request(name, args)
    print("REQUEST", name)
    if args then
        for k,v in pairs(args) do
            print(k,v)
        end
    end
end

function MessageManager:print_response(session, args)
    print("RESPONSE", 0)
    if args then
        for k,v in pairs(args) do
            print(k,v)
        end
    end
end
-- function MessageManager:recv_package(last)
--     local result
--     result, last = unpack_package(last)
--     if result then
--         return result, last
--     end
--     local r = socket.recv(fd)
--     if not r then
--         return nil, last
--     end
--     if r == "" then
--         error "Server closed"
--     end
--     return unpack_package(last .. r)
-- end

-- function MessageManager:dispatch_package()
--     while true do
--         local v
--         v, last = recv_package(last)
--         if not v then
--             break
--         end
--         print_package(host:dispatch(v))
--     end
-- end

return MessageManager
