local variables = require("variables");
local button = {};

function button.make()
    local result = {
        lightPos = {
            x = math.ceil(math.random() * variables.fieldSize.x);
            y = math.ceil(math.random() * variables.fieldSize.y);
        },
        on = false,
        draw = function(x, y)
            love.graphics.setColor(0,0,128)
            love.graphics.rectangle("fill", x, y, variables.tileSize, variables.tileSize);
        end
    };
    return result;
end

return button;