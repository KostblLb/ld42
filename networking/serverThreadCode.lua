local enet = require "enet"
local config = require "networking.config"
local host = enet.host_create(config.host)
love.thread.getChannel("log"):push(host:get_socket_address())
local binser = require "binser"

love.thread.getChannel("log"):push("started server")
host:service()
local lastServiceTime = os.clock()
while true do
    if math.abs(os.clock() - lastServiceTime) >= config.delay / 1000 then
        lastServiceTime = os.clock()
        local eventsInFrame = 0
        local event = host:service()
        while event do
            eventsInFrame = eventsInFrame + 1
            if event.type == "receive" then
                local data = binser.deserialize(event.data)[1]
                if data.timestamp then data.timestamp = data.timestamp + 2 * event.peer:last_round_trip_time() / 1000 end
                if (type(data) == "table") then
                    love.thread.getChannel("fromPeer"):push(data)
                else
                    love.thread.getChannel("log"):push(data)
                end
            elseif event.type == "connect" then
                print(event.peer, "connected.")
                love.thread.getChannel("log"):push("Client connected")
            elseif event.type == "disconnect" then
                print(event.peer, "disconnected.")
                love.thread.getChannel("log"):push("disconnected")
            end
            event = host:service()
        end

        love.thread.getChannel("log"):push("events in frame: " .. eventsInFrame)

        local toPeerChannel = love.thread.getChannel("toPeer")
        local msg = toPeerChannel:pop()
        if msg then host:broadcast(binser.serialize(msg)) end
        toPeerChannel:clear()
        host:flush()
    end
end