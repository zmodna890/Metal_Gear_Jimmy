Maze = Class{}

function Maze:init(x, y)
    self.x = x
    self.y = y
    self.moves = {}
    self.maze = {}

    self:initializeMaze()
end


-- Initializes a 9x9 maze
function Maze:initializeMaze()
    -- Create an empty 2D array of maze and moves
    for row = 1, 9 do
        -- Insert an empty row
        table.insert(self.maze, {})
        table.insert(self.moves, {})
        for col = 1, 9 do
            -- Initialize current tile with 1 (walls)
            self.maze[row][col] = Tile(row, col, 1)
            -- Initialize current tile with no camera
            self.moves[row][col] = false
        end
    end

    -- Randomly create a path to make maze solvable
    self:createPath()
end


-- Randomly creates a path in the maze
function Maze:createPath()
    -- Start at random row and col 1 (left side) of the maze
    local row, col = math.random(2, 8), 1

    -- Store starting point of the maze
    self.row, self.col = row, col

    -- Create a starting point on the maze
    self.maze[row][col] = Tile(row, col, 0)
    
    while true do
        -- Check if we reached the right col of the maze (finish)
        if col == 9 then
            break
        end
        -- Get an array of available spaces
        local availSpace = self:availableSpaces(row, col)

        -- Randomly select a movement
        move = math.random(#availSpace)

        -- Parse the randomly selected movement
        row, col = self:parseMovement(availSpace[move], row, col)

        self.maze[row][col] = Tile(row, col, 0)
    end
end


-- Returns a table of available moves based on current tile
function Maze:availableSpaces(row, col)
    -- Initialize available spaces
    -- Left, Up, Right, Down
    local availSpace = {'left', 'up', 'right', 'down'}
    -- If the current position is at the left col,
    -- increase chance of right
    if col <= 2 then
        availSpace[1] = 'right'
        -- Remove up/down if we're at the left col
        if col == 1 then
            availSpace[2] = 'right'
            availSpace[4] = 'right'
        end
    end
    -- increase chance of down if top row
    if row == 2 and col ~= 1 then
        availSpace[2] = 'down'
    end
    -- increase chance of up if bottom row
    if row == 8 and col ~= 1 then
        availSpace[4] = 'up'
    end

    return availSpace
end


-- Parses a string of move and returns row and col
function Maze:parseMovement(move, row, col)
    if move == 'left' then
        col = col - 1
    elseif move == 'up' then
        row = row - 1
    elseif move == 'right' then
        col = col + 1
    else
        row = row + 1
    end

    return row, col
end


-- Returns true if the tile is a wall
function Maze:isWall(row, col)
    return (row <= 0 or row >= 10) or (col <= 0 or col >= 10) or (self.maze[row][col].object == 1)
end


-- Enters a tile coords in moves table
function Maze:enterMove(row, col)
    self.moves[row][col] = true
end


-- Returns a bool if the tile has a camera
function Maze:hasCamera(row, col)
    return self.moves[row][col]
end


-- Renders the maze and cameras
function Maze:render()
    -- Render walls and tiles
    for row = 1, #self.maze do
        for col = 1, #self.maze[1] do
            self.maze[row][col]:render(self.x, self.y, self:hasCamera(row, col))
        end
    end

    -- Render movement guide
    local text = "MOVEMENT GUIDE:\nW (up)\nS (down)\nA (left)\nD (right)\nQ (select)"
    local x = VIRTUAL_WIDTH - gFonts['large']:getWidth(text) - 10
    local y = (VIRTUAL_HEIGHT / 2) - gFonts['large']:getHeight(text)

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.print(text, x + 2, y + 1)
    love.graphics.print(text, x + 1, y + 1)
    love.graphics.print(text, x, y + 1)
    love.graphics.print(text, x + 1, y + 2)
    love.graphics.setColor(210/255, 191/255, 177/255, 1)
    love.graphics.print(text, x, y)
end