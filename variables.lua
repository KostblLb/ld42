local variables = {
    speed = 8; -- tiles per second
    tileSize = 16;
    fieldSize = { -- in tiles
        x = 16,
        y = 32
    };
    smallFont = nil,
    bigFont = nil,
    display = {
        width = 800,
        height = 600
    },
    p1Keys = {
        left = "a",
        right = "d",
        up = "w",
        down = "s"
    },
    p2Keys = {
        left = "left",
        right = "right",
        up = "up",
        down = "down"
    }
}

return variables;