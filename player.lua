local variables = require("variables");
local field = require("field");

local player = {};
function player.move(f, p, dt)
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
    p.x = p.x + (dx * variables.speed);
    p.y = p.y + (dy * variables.speed);
end

PLAYER_WIDTH = variables.tileSize;
PLAYER_HEIGHT = variables.tileSize * 2;
function player.draw(p)
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", p.x, p.y - PLAYER_HEIGHT, PLAYER_WIDTH, PLAYER_HEIGHT);
end

return player ;
