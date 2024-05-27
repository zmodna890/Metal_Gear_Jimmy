Tile = Class{}

function Tile:init(row, col, object)
    -- Storing col for start and end objects
    self.col = col
    -- (X, Y) on 2D coords
    self.x = (col - 1) * TILESIZE
    self.y = (row - 1) * TILESIZE

    -- Whether a wall (box) or empty space
    -- 0 == space, 1 == wall (box)
    self.object = object
end


-- (X, Y) that is passed in is the (X, Y) of the maze (top-left)
function Tile:render(x, y, camera)
    if self.object == 1 then
        love.graphics.setColor(91/255, 1, 65/255, 1)
    else
        if self.col == 1 then
            love.graphics.setColor(1, 0, 0, 1)
        elseif self.col == 9 then
            love.graphics.setColor(0, 1, 0, 1)
        else
            love.graphics.setColor(130/255, 130/255, 130/255, 1)
        end
    end

    love.graphics.draw(gTextures[self.object], self.x + x, self.y + y,
    0, self.object == 0 and 1/20 or 1/3.515625, self.object == 0 and 1/20 or 1/3.515625)

    if camera then
        love.graphics.setColor(1, 0, 0, 130/255)
        -- Render red circle, with starting point on the middle of the tile
        love.graphics.circle('fill', 
            x + self.x + TILESIZE/2,
            y + self.y + TILESIZE/2,
            TILESIZE/2)
    end
end