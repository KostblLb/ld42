local variables = require("variables");
local button = {
    draw = function(self, light, x, y, nearPlayer)
        if (light == 0 and not self.on and not nearPlayer) then return end
        local phase = math.floor(self.timer);
        love.graphics.setColor((phase % 2 == 1) and 1 or 0, ((phase % 4) > 1) and 1 or 0, self.on and ((phase % 4 == 0 or phase % 4 == 3) and 1 or 0) or 0.6)
        love.graphics.rectangle("fill", x, y, variables.tileSize, variables.tileSize);
    end
};

function button.make()
    local result = {
        on = false,
        timer = 0,
        light = nil,
        draw = button.draw,
    };
    return result;
end

return button;