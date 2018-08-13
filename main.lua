local variables = require "variables";
local player = require "player";
local field = require "field";
local health = require "health";
local screen = require "screen"

math.randomseed(os.clock())

local fields = {}
local function makeFields()
    fields = { field.generate(10, 600 - 10 - variables.fieldSize.y * variables.tileSize), field.generate(800 - 10 - variables.fieldSize.x * variables.tileSize, 10) };
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
        dx = 0,
        dy = 0,
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
        key = {
            left = "a",
            right = "d",
            up = "w",
            down = "s"
        }
    };

    local p2RandomCell = field.randomCell();
    local p2Pos = field.getCellPos(fields[2], p2RandomCell.x, p2RandomCell.y)
    local p2 = {
        x = p2Pos.x,
        y = p2Pos.y,
        dx = 0,
        dy = 0,
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
        key = {
            left = "left",
            right = "right",
            up = "up",
            down = "down"
        }
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

    love.audio.play(love.audio.newSource("bell.mp3", "stream"))
    SOUND_BURN = love.audio.newSource("burning.mp3", "stream")
    love.audio.play(SOUND_BURN);
    love.audio.pause(SOUND_BURN);
    SOUND_DEATH = love.audio.newSource("death.mp3", "stream")
end

function love.update(dt)
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
            player.move(f, p, dt);
            field.playerInteract(f, p, dt);
            health.damage(p, f)
            local playerPos = field.getCellTilePos(f, math.min(p.x + variables.tileSize / 2, variables.fieldSize.x * variables.tileSize + f.offset.x), math.max(p.y - variables.tileSize / 2, f.offset.y))
            burns = burns or f.light[playerPos.x][playerPos.y] >= field.CELL_DANGEROUS
        end
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
end

function love.draw()
    love.graphics.setColor(0,0,0)
    love.graphics.clear();
    for i = 1, 2 do
        local f = fields[i];
        local p = players[i];
        field.draw(f, p);
        local tilePos = field.getCellTilePos(f, p.x, p.y);
        love.graphics.setColor(255,255,255)
        player.draw(p);
        screen.draw(p);
        -- love.graphics.print("(" .. tilePos.x .. " ; " .. tilePos.y .. ")", p.x + 20, p.y + 20)
        love.graphics.print(p.hp > 0 and p.hp or "DEAD", p.x, p.y + 10)
        screen.timescreen(wins[i], i, gameover, winner);
    end
end

-- for k,v in pairs(player) do print(k, v) end