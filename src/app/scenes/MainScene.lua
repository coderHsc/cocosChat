
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)
local SocketManager = require("app.scenes.socket_manager")

function MainScene:ctor()
     SocketManager:init()
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
