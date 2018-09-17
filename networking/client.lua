local client = {
    connect = function()
        Debug.log("connecting to server...")
        local thread = love.thread.newThread("networking/clientThreadCode.lua")
        thread:start()
    end
}

return client