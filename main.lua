local variables = require "variables";
local player = require "player";
local field = require "field";

math.randomseed(os.clock())

local fields = { field.generate(40, 60), field.generate(532, 20) };
fields[1].friend = fields[2];
fields[2].friend = fields[1];

local p1RandomCell = field.randomCell();
local p1Pos = field.getCellPos(fields[1], p1RandomCell.x, p1RandomCell.y)
local p1 = {
    x = p1Pos.x,
    y = p1Pos.y,
    dx = 0,
    dy = 0,
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
    key = {
        left = "j",
        right = "l",
        up = "i",
        down = "k"
    }
};
local players = {[1] = p1, [2] = p2};

function love.load()
    love.graphics.setNewFont(12)
    love.graphics.setColor(0,0,0)
    love.graphics.setBackgroundColor(255,255,255)
end

function love.update(dt)
    for i = 1, 2 do
        local p = players[i];
        local f = fields[i];
        player.move(f, p, dt);
        field.playerInteract(f, p);
    end
end

function love.draw()
    love.graphics.setColor(0,0,0)
    love.graphics.clear();
    for i = 1, 2 do
        local f = fields[i];
        field.draw(f);
        local p = players[i];
        player.draw(p);
        love.graphics.setColor(255,255,255)
        local tilePos = field.getCellTilePos(f, p.x, p.y);
        love.graphics.print("(" .. tilePos.x .. " ; " .. tilePos.y .. ")", p.x + 20, p.y + 20)
    end
end

-- for k,v in pairs(player) do print(k, v) end