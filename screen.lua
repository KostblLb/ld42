local variables = require("variables")
local screen = {}

function screen.timescreen(wins, i, gameover, winner)
    love.graphics.setFont(variables.bigFont);
    love.graphics.setColor(1,1,1);
    love.graphics.print("P".. i .. " WINS: " .. wins, 300, 30 + 480 * (i - 1));
    if (gameover) then
        love.graphics.print({{1, 1, 1}, "WINNER:\n", {1, 0.3, 0.3}, winner and ("P" .. winner) or "NOBODY"}, 300, 300)
    end
    love.graphics.setFont(variables.smallFont);
    love.graphics.print("(spacebar to restart)", 300, 560);
end


function screen.draw(p)
    local k = 0;
    if p.hp ~= 0 then
            for i = 1, p.hp/5 do
              love.graphics.setColor(255,255,255)
               love.graphics.rectangle("fill", p.hpbarx + k, p.hpbary, 5, 15)
               k = k + 10
             end
    end
end
return screen