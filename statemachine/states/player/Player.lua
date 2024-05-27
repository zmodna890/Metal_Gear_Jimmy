Player = Class{}

function Player:init(def)
    -- Statemachine
    self.stateMachine = def.stateMachine
    self.direction = 'right'

    -- Reference to maze
    self.maze = def.maze
    -- Coordinates in maze
    self.mazeRow = self.maze.row
    self.mazeCol = self.maze.col

    self.x = self.maze.x
    self.y = self.maze.y + (self.mazeRow - 1) * TILESIZE
end


-- Changes to a different state (assuming it exists)
function Player:changeState(state, params)
    self.stateMachine:change(state, params)
end


-- Updates the current player state
function Player:update(dt)
    self.stateMachine:update(dt)
end


-- Renders the agent
function Player:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['agent'], gFrames['agent'][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 15, 0, 
            TILESIZE/22,
            TILESIZE/46)
end


-- Returns true if the player reached the goal
function Player:reachedGoal()
    return self.mazeCol == 9
end