local ui = {}
local state = require "state"

local client = require "networking.client"
local server = require "networking.server"

local DISCONNECTED = 0
local HOST = 1
local CLIENT = 2
local WAITING = 3

local hostBtn = {
    draw = function(self)
        love.graphics.setColor(0.6, 0.6, 1)
        love.graphics.circle("fill", 10, 10, 10)
    end,
    hasCursor = function(x, y)
        return x > 0 and x <= 20 and y >= 0 and y <= 20
    end,
}

local clientBtn = {
    draw = function()
        love.graphics.setColor(0.6, 1, 0.6)
        love.graphics.circle("fill", 40, 10, 10)
    end,
    hasCursor = function(x, y)
        return x > 30 and x <= 50 and y >= 0 and y <= 20
    end,
}

local function draw(self)
    for k, v in pairs(self.controls) do
        v.draw()
    end
end

function ui.new()
    local result = {
        state = DISCONNECTED,
        addr = "0.0.0.0:2345",
        draw = draw,
    }
    result.controls = {
        [1] = {
            draw = hostBtn.draw,
            hasCursor = hostBtn.hasCursor,
            onClick = function()
                result.state = HOST
                GameState.networkingRole = "host"
                GameState.networkControlledPlayer = 2
                server.start()
            end
        },
        [2] = {
            draw = clientBtn.draw,
            hasCursor = clientBtn.hasCursor,
            onClick = function()
                result.state = CLIENT
                GameState.networkingRole = "client"
                GameState.networkControlledPlayer = 1
                client.connect()
            end
        }
    }
    return result
end

return ui