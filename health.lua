local health = {}
local field = require "field"
local variables = require "variables"

function health.damage(p, f)
    if p.hp == 0
    then return
    end
    local pos = field.getCellTilePos(f, p.x + variables.tileSize / 2, p.y - variables.tileSize / 2)
    if love.timer.getTime() - 0.3 > p.time
    then
        if f.light[pos.x][pos.y] >= field.CELL_DANGEROUS
        then
            p.hp = p.hp - 5;
            p.time = love.timer.getTime()
        end
     end
end

return health