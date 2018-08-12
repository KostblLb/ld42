local health = {}
local field = require "field"

function health.damage(p, f)
    if p.hp == 0
    then return
    else
    end
    pos = field.getCellTilePos(f, p.x, p.y)
    if love.timer.getTime() - 0.3 > p.time
    then 
        if f.light[pos.x][pos.y] == field.CELL_DANGEROUS
                    then
                 p.hp = p.hp - 5;
                 p.time = love.timer.getTime()
                 end
     end
end

return health