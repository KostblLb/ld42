local screen = {}

function timescreen(x, y)
    love.graphics.print({3, love.timer.getTime}, 10, 10)
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