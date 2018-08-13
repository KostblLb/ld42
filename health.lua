local health = {}
local field = require "field"
local variables = require "variables"

function health.damage(p, f)
    if p.hp == 0
    then return
    end
    local pos = field.getCellTilePos(f, math.min(p.x + variables.tileSize / 2, variables.fieldSize.x * variables.tileSize + f.offset.x), math.max(p.y - variables.tileSize / 2, f.offset.y))
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