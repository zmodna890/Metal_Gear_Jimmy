-- [sprite1, sprite2, ...]
function GenerateQuads(atlas)
    -- Hardcoding since the sprites' dimensions are not the same size
    local spritesheet = {}
    local x = 0
    local tilewidth, tileheight = 15, 31

    for i = 1, 8 do
        spritesheet[i] =
            love.graphics.newQuad(x, 0, tilewidth,
            tileheight, atlas:getDimensions())
        -- Update x coords for the next sprite
        x = x + tilewidth
    end

    tilewidth = 16
    x = 120

    for i = 9, 12 do
        spritesheet[i] =
            love.graphics.newQuad(x, 0, tilewidth,
            tileheight, atlas:getDimensions())
        -- Update x coords
        x = x + tilewidth
    end

    return spritesheet
end