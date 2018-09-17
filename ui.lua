local ui = {}

local function draw(self)
    for key, container in pairs(self.containers) do
        for _, control in pairs(container.controls) do
            control.draw()
        end
    end
end

local function add(self, container)
    self.containers[#(self.containers) + 1] = container
end

local function onClick(self, x, y)
    for key, container in pairs(self.containers) do
        for _, control in pairs(container.controls) do
            if (type(control.hasCursor) == "function" and type(control.onClick) == "function" and control.hasCursor(x, y)) then
                control.onClick()
            end
        end
    end
end

function ui.new()
    return {
        containers = {},
        draw = draw,
        add = add,
        onClick = onClick,
    }
end

return ui