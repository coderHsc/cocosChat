cc.utils                = require("framework.cc.utils.init")
cc.net                  = require("framework.cc.net.init")
MessageManager          = require("app.scenes.message_manager")


SocketManager = class("SocketManager")

self = SocketManager


function SocketManager:init()
	if not self._socket then
        self._socket = cc.net.SocketTCP.new("192.168.38.21", 8888, false)
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED, handler(self, self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSE, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(self,self.onData))
    end
    self._socket:connect()
end

function SocketManager:onData(__event)
   
    local data = MessageManager:unpack_package(__event.data)
    MessageManager:print_package(data)
   -- print("onData",data)



    --session = session + 1
    --local str = request("get",{ what = "hello" }, session)
    --local size = #str
    local data = MessageManager:pack_package("str")

    --local pack = string.char(extract(size,8,8)) .. string.char(extract(size,0,8)) .. str


    -- print("pack",pack,size,#pack)
  
    self._socket:send(data)

end

--给服务器发送消息
function SocketManager:onStatus(__event)
    print("onStatus",__event.name)
  
end

return SocketManager