local variables = require "variables";
local player = require "player";
local field = require "field";
local health = require "health";

math.randomseed(os.clock())

local fields = { field.generate(10, 600 - 10 - variables.fieldSize.y * variables.tileSize), field.generate(800 - 10 - variables.fieldSize.x * variables.tileSize, 10) };
fields[1].friend = fields[2];
fields[2].friend = fields[1];

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
    aura = {
        r = 1,
        g = 0,
        b = 0.1
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
    image = love.graphics.newImage("ghost.png"),
    aura = {
        r = 0.2,
        g = 0.1,
        b = 1
    },
    key = {
        left = "left",
        right = "right",
        up = "up",
        down = "down"
    }
};
local players = {[1] = p1, [2] = p2};

function love.load()
    love.graphics.setNewFont("FTY_IRONHORSE_NCV.ttf", 24)
    love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(1,1,1)
end

function love.update(dt)
    for i = 1, 2 do
        local p = players[i];
        local f = fields[i];
        player.move(f, p, dt);
        field.playerInteract(f, p, dt);
        health.damage(p, f)
        _dt = dt;
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
        love.graphics.print("(" .. tilePos.x .. " ; " .. tilePos.y .. ")", p.x + 20, p.y + 20)
        love.graphics.print(p.hp > 0 and p.hp or "DEAD", p.x, p.y)
    end
end

-- for k,v in pairs(player) do print(k, v) end