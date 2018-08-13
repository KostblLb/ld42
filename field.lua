local variables = require("variables");
local button = require("button");

local field = {}

field.CELL_DANGEROUS = 2;
field.CELL_VISIBLE = 1;
field.CELL_DARK = 0;

local function getCellTilePos(f, x, y)
    return {
        x = math.floor((math.floor(x) - f.offset.x) / variables.tileSize) + 1,
        y = math.floor((math.floor(y) - f.offset.y) / variables.tileSize) + 1
    };
end
field.getCellTilePos = getCellTilePos;

function field.getCellPos(f, x, y)
    return {
        x = f.offset.x + (x - 1) * variables.tileSize,
        y = f.offset.y + (y - 1) * variables.tileSize,
    }
end

function field.playerInteract(f, p)
    local tilePos = getCellTilePos(f, p.x, p.y);
    local obj = f.objects[tilePos.x][tilePos.y];
    if (obj and not obj.on) then
        obj.on = true;
        local pos = field.randomCell();
        field.addLight(f.friend, pos.x, pos.y);
    end
end

function field.generate(x, y)
    local result = { objects = {}, light = {}, offset = {x = x, y = y}, friend = nil };
    for i = 1, variables.fieldSize.x do
        result.objects[i] = {};
        result.light[i] = {};
        for j = 1, variables.fieldSize.y do
            result.light[i][j] = field.CELL_DARK;
            if (math.random() > 0.95) then
                result.objects[i][j] = button.make()
            else
                result.objects[i][j] = nil;
            end
        end
    end
    return result;
end



function field.getAllowedDirections(f, x, y)
    local tilePos = getCellTilePos(f, x, y);
    return {
        left = tilePos.x > 0,
        right = tilePos.x < variables.fieldSize.x,
        up = tilePos.y > 1,
        down = tilePos.y < variables.fieldSize.y + 1,
    }
end

local COLOR = {255, 255, 0}
local COLOR_ALPHA = {
    [ field.CELL_DANGEROUS] = 0.8,
    [field.CELL_VISIBLE] = 0.6,
    [field.CELL_DARK] = 0.3
}

local function drawLight(x, y, lightness)
    love.graphics.setColor(COLOR[1], COLOR[2], COLOR[3], COLOR_ALPHA[lightness]);
    love.graphics.rectangle("fill", x, y, variables.tileSize, variables.tileSize);
end

function field.draw(f)
    love.graphics.setColor(255,255,255);
    love.graphics.rectangle("line", f.offset.x, f.offset.y, variables.tileSize * variables.fieldSize.x, variables.tileSize * variables.fieldSize.y);
    for i = 1, variables.fieldSize.x do
        for j = 1, variables.fieldSize.y do
            local pos = field.getCellPos(f, i, j);
            if (f.objects[i][j]) then f.objects[i][j].draw(f.objects[i][j], f.light[i][j], pos.x, pos.y) end
            drawLight(pos.x, pos.y, f.light[i][j]);
        end
    end
end

local DANGER_ZONE_RADIUS = 1;
local VISIBLE_ZONE_RADIUS = 3;
function field.addLight(f, x, y)
    f.light[x][y] =  field.CELL_DANGEROUS;
    for i=math.max(1, x - VISIBLE_ZONE_RADIUS), math.min(variables.fieldSize.x, x + VISIBLE_ZONE_RADIUS) do
        for j = math.max(1, y - VISIBLE_ZONE_RADIUS), math.min(variables.fieldSize.y, y + VISIBLE_ZONE_RADIUS) do
            if (f.light[i][j] == field.CELL_VISIBLE or f.light[i][j] ==  field.CELL_DANGEROUS) then
                f.light[i][j] =  field.CELL_DANGEROUS;
            else
                f.light[i][j] = field.CELL_VISIBLE;
            end
        end
    end
    for i=math.max(1, x - DANGER_ZONE_RADIUS), math.min(variables.fieldSize.x, x + DANGER_ZONE_RADIUS) do
        for j = math.max(1, y - DANGER_ZONE_RADIUS), math.min(variables.fieldSize.y, y + DANGER_ZONE_RADIUS) do
            f.light[i][j] =  field.CELL_DANGEROUS;
        end
    end
end


function field.randomCell()
    return {
        x = math.floor(1 + math.random() * variables.fieldSize.x),
        y = math.floor(1 + math.random() * variables.fieldSize.y)
    }
end

return field;
