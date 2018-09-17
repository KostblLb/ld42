

local variables = require "variables";
local player = require "player";
local field = require "field";
local health = require "health";
local screen = require "screen";
local ui = require "ui";
local networking = {
    server = require "networking.server",
    client = require "networking.client",
    ui = require "networking.ui",
    config = require "networking.config",
};

local gtime = 0
local function timestamp(dt)
    gtime = gtime + dt
    return gtime
end

local logfile = io.open("log.txt", "a+")
Debug = {
    messages = {},
    log = function(...)
        local arg = {...}
        local msg = ""
        if (type(arg) == "table") then
            for i, v in ipairs(arg) do msg = msg .. " " .. tostring(v) end
        else msg = arg or "" end

        logfile:write(os.date("!%c") .. " " .. (GameState.networkingRole or "") .. (msg or "") .. "\n")
        --logfile:close()
        Debug.messages[#Debug.messages + 1] = msg
    end,
    draw = function()
        if (#Debug.messages == 0) then return end
        love.graphics.setColor(1,0.5,0.5)
        for i = 1, math.min(#Debug.messages, 5) do
            love.graphics.print(Debug.messages[#Debug.messages - i + 1], 0, variables.display.height - i * 20)
        end
    end
}

GameState = {
    timestamp = 0,
    players = {
        [1] = {
            pos = {
                x = 0.5,
                y = 0.5,
            },
            dir = "",
        },
        [2] = {
            pos = {
                x = 0.5,
                y = 0.5,
            },
            dir = "",
        }
    },
    --fields = nil,
    networkControlledPlayer = 2,
    networkingRole = nil,
}

math.randomseed(os.clock())

local mainUI = ui.new();

local fields = {}
local function makeFields()
    fields = { field.generate(10, 600 - 10 - variables.fieldSize.y * variables.tileSize), field.generate(800 - 10 - variables.fieldSize.x * variables.tileSize, 10) };
    --GameState.fields = fields;
    fields[1].friend = fields[2];
    fields[2].friend = fields[1];
end

local p1;
local p2;
local players = {}

local function makePlayers()
    local p1RandomCell = field.randomCell();
    local p1Pos = field.getCellPos(fields[1], p1RandomCell.x, p1RandomCell.y)
    local p1 = {
        x = p1Pos.x,
        y = p1Pos.y,
        hp = 50,
        time = 0,
        image = love.graphics.newImage("vampire.png"),
        dead = love.graphics.newImage("dust.png"),
        hpbarx = 95,
        hpbary = 45,
        aura = {
            r = 1,
            g = 0,
            b = 0.1,
            a = 0.3
        },
        key = variables.p1Keys
    };

    local p2RandomCell = field.randomCell();
    local p2Pos = field.getCellPos(fields[2], p2RandomCell.x, p2RandomCell.y)
    local p2 = {
        x = p2Pos.x,
        y = p2Pos.y,
        hp = 50,
        time = 0,
        image = love.graphics.newImage("vampire3.png"),
        dead = love.graphics.newImage("dust.png"),
        hpbarx = 610,
        hpbary = 550,
        aura = {
            r = 0.2,
            g = 0.1,
            b = 1,
            a = 0
        },
        key = variables.p2Keys
    };
    players = {[1] = p1, [2] = p2};
end

local wins = {0, 0}
local gameover = false;
local winner = nil;

function love.load()
    variables.smallFont = love.graphics.setNewFont("FTY_IRONHORSE_NCV.ttf", 24);
    variables.bigFont = love.graphics.setNewFont("FTY_IRONHORSE_NCV.ttf", 50);
    love.graphics.setNewFont("FTY_IRONHORSE_NCV.ttf", 24)
    love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(1,1,1)
    makeFields()
    makePlayers()

    --love.audio.play(love.audio.newSource("bell.mp3", "stream"))
    SOUND_BURN = love.audio.newSource("burning.mp3", "stream")
    love.audio.play(SOUND_BURN);
    love.audio.pause(SOUND_BURN);
    SOUND_DEATH = love.audio.newSource("death.mp3", "stream")

    mainUI:add(networking.ui.new())
    Debug.log("game start")
end

function love.mousepressed(x, y, button, isTouch, presses)
    mainUI:onClick(x, y)
end

local toSync = false
function love.update(dt)
    local peerState = love.thread.getChannel('fromPeer'):pop()
    toSync = toSync or love.thread.getChannel('sync'):pop()

    if (toSync and peerState) then
        Debug.log("synced")
        gtime = peerState.timestamp
        toSync = false
    end

    local tstamp = timestamp(dt)

    if (love.keyboard.isDown("space")) then
        makeFields()
        makePlayers()
        gameover = false
        return
    end
    if (not gameover) then
        local burns = false
        for i = 1, 2 do
            local p = players[i];
            local f = fields[i];
            local dir = ""
            if GameState.networkingRole and i == GameState.networkControlledPlayer then
                local state = peerState or GameState
                if peerState then
                    GameState.players[i].dir = peerState.players[i].dir
                end
                newPos = field.getAbsolutePos(f, state.players[i].pos.x, state.players[i].pos.y)
                p.x, p.y = newPos.x, newPos.y
                player.move(f, p, state.players[i].dir, tstamp - state.timestamp)
            else
                local dir = player.getDirection(p.key)
                x, y, moved = player.move(f, p, dir, dt);
                GameState.players[i].dir = dir
            end
            GameState.players[i].pos = field.getRelativePos(f, p.x, p.y)

            field.playerInteract(f, p, dt);
            health.damage(p, f)

            local playerTilePos = field.getCellTilePos(f, math.min(p.x + variables.tileSize / 2, variables.fieldSize.x * variables.tileSize + f.offset.x), math.max(p.y - variables.tileSize / 2, f.offset.y))
            burns = burns or f.light[playerTilePos.x][playerTilePos.y] >= field.CELL_DANGEROUS
        end

        GameState.timestamp = tstamp
        love.thread.getChannel("toPeer"):push(GameState)

        if (burns) then love.audio.play(SOUND_BURN)
        else love.audio.pause(SOUND_BURN) end

        if (players[1].hp <= 0 or players[2].hp <= 0) then
            gameover = true
            if (players[1].hp > 0) then wins[1] = wins[1] + 1; winner = 1;
            elseif (players[2].hp > 0) then wins[2] = wins[2] + 1; winner = 2;
            else winner = nil;
            end
            love.audio.play(SOUND_DEATH)
        end
    end

    local logChannelMsg = love.thread.getChannel("log"):pop()
    if logChannelMsg then Debug.log(logChannelMsg) end
end

function love.draw()
    love.graphics.setColor(0,0,0)
    love.graphics.clear();
    for i = 1, 2 do
        local f = fields[i];
        local p = players[i];
        field.draw(f, p);
        local tilePos = field.getCellTilePos(f, p.x, p.y);
        love.graphics.setColor(1, 1, 1)
        player.draw(p);
        screen.draw(p);
        -- love.graphics.print("(" .. tilePos.x .. " ; " .. tilePos.y .. ")", p.x + 20, p.y + 20)
        love.graphics.print(p.hp > 0 and p.hp or "DEAD", p.x, p.y + 10)
        screen.timescreen(wins[i], i, gameover, winner);
    end

    mainUI:draw()
    Debug.draw()
end

function love.threaderror(thread, err)
    Debug.log(err)
end

-- for k,v in pairs(player) do print(k, v) end