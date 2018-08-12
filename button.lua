local variables = require("variables");
local button = {
    draw = function(self, light, x, y)
        if (light == 0 and not self.on) then return end
        love.graphics.setColor(0, self.on and 128 or 0, not self.on and 128 or 0)
        love.graphics.rectangle("fill", x, y, variables.tileSize, variables.tileSize);
    end
};

function button.make()
    local result = {
        lightPos = {
            x = math.ceil(math.random() * variables.fieldSize.x);
            y = math.ceil(math.random() * variables.fieldSize.y);
        },
        on = false,
        draw = button.draw
    };
    return result;
end

return button;