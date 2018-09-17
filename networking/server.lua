local server = {
    start = function()
        local thread = love.thread.newThread("networking/serverThreadCode.lua")
        thread:start()
    end
}

return server