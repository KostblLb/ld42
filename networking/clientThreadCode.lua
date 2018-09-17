local enet = require "enet"
local config = require "networking.config"
local host = enet.host_create()
local peer = host:connect(config.host)
local player = require "player"
local variables = require "variables"
local binser = require "binser"
require "love.keyboard"

host:service()
local lastServiceTime = os.clock()
while true do
    --love.thread.getChannel("log"):push("time " .. os.clock() .. " " .. lastServiceTime)
    if math.abs(os.clock() - lastServiceTime) >= config.delay / 1000  then
        lastServiceTime = os.clock()
        local event = host:service()
        while event do
            if event.type == "receive" then
                local data = binser.deserialize(event.data)[1]
                if type(data) == "table" then
                    love.thread.getChannel("fromPeer"):push(data)
                else
                    love.thread.getChannel("log"):push(data)
                end
            elseif event.type == "connect" then
                love.thread.getChannel('log'):push("Connected to server")
                love.thread.getChannel("sync"):push(true)
            elseif event.type == "disconnect" then
                print(event.peer, "disconnected.")
                love.thread.getChannel('log'):push("disconnected")
            end
            event = host:service()
        end

        local toPeerChannel = love.thread.getChannel("toPeer")
        local msg = toPeerChannel:pop()
        if msg then host:broadcast(binser.serialize(msg)) end
        toPeerChannel:clear()
        host:flush()
    end
end