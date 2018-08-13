local variables = require("variables");
local field = require("field");

local player = {};
function player.move(f, p, dt)
    if p.hp == 0 then return end
    local allowedDirections = field.getAllowedDirections(f, p.x, p.y);
    local dx = 0; local dy = 0;
    if (allowedDirections.left and love.keyboard.isDown(p.key.left)) then
        dx = -dt;
    end
    if (allowedDirections.up and love.keyboard.isDown(p.key.up)) then
        dy = -dt;
    end
    if (allowedDirections.right and love.keyboard.isDown(p.key.right)) then
        dx = dt;
    end
    if (allowedDirections.down and love.keyboard.isDown(p.key.down)) then
        dy = dt;
    end
    p.x = math.max(f.offset.x, p.x + (dx * variables.speed));
    p.y = math.max(f.offset.y, p.y + (dy * variables.speed));
end

local PLAYER_WIDTH = variables.tileSize;
local PLAYER_HEIGHT = variables.tileSize * 2;

function player.draw(p)
   -- love.graphics.setColor(255,255,255)
   -- love.graphics.rectangle("fill", p.x, p.y - PLAYER_HEIGHT, PLAYER_WIDTH, PLAYER_HEIGHT);
    if p.hp == 0 then
        love.graphics.draw(p.dead, p.x, p.y - PLAYER_HEIGHT, 0, 0.5)
    else
        love.graphics.setColor(p.aura.r, p.aura.g, p.aura.b, p.aura.a)
        love.graphics.rectangle("fill", p.x - PLAYER_WIDTH / 2, p.y - PLAYER_HEIGHT * 0.75, PLAYER_WIDTH * 2, PLAYER_HEIGHT);
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(p.image, p.x, p.y - PLAYER_HEIGHT, 0, 1.25)
        love.graphics.draw(p.image, p.x, p.y - PLAYER_HEIGHT, 0, 1.25)
    end
end

return player ;