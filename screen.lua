local variables = require("variables")
local screen = {}

function screen.timescreen(wins, i, gameover, winner)
    love.graphics.setFont(variables.bigFont);
    love.graphics.setColor(1,1,1);
    love.graphics.print("P".. i .. " WINS: " .. wins, 300, 10 + 530 * (i - 1));
    if (gameover) then
        love.graphics.print({{1, 1, 1}, "WINNER:\n", {1, 0.3, 0.3}, winner and ("P" .. winner) or "NOBODY"}, 300, 300)
    end
    love.graphics.setFont(variables.smallFont);
end

function screen.draw(p)
     love.graphics.setColor(255,255,255)
    -- love.graphics.rectangle("fill", p.hpbar, 45, 5, 15)
     love.graphics.rectangle("fill", 100, 45, 5, 15)
end
return screen