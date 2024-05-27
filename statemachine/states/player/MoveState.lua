MoveState = Class{__includes = BaseState}

function MoveState:init(player)
    self.player = player
    self.animation = Animation {
        frames = {},
        interval = 0.1
    }

    self.player.currentAnimation = self.animation

end


function MoveState:enter()
    -- The tile the agent is trying to reach (pixels)
    -- We just need to keep track of either x or y based on direction
    self.tileGoal = 0
    -- Keep track of current tile before moving to the tile goal for camera purposes
    self.prevRow, self.prevCol = self.player.mazeRow, self.player.mazeCol
    -- Update animation frames based on the current player's direction
    if self.player.direction == 'left'
    and not self.player.maze:isWall(self.player.mazeRow, self.player.mazeCol - 1) then
        self.animation.frames = {11, 12}
        self.player.mazeCol = self.player.mazeCol - 1
        self.tileGoal = self.player.x - TILESIZE
    elseif self.player.direction == 'up'
    and not self.player.maze:isWall(self.player.mazeRow - 1, self.player.mazeCol) then
        self.animation.frames = {5, 6}
        self.player.mazeRow = self.player.mazeRow - 1
        self.tileGoal = self.player.y - TILESIZE
    elseif self.player.direction == 'right'
    and not self.player.maze:isWall(self.player.mazeRow, self.player.mazeCol + 1) then
        self.animation.frames = {9, 10}
        self.player.mazeCol = self.player.mazeCol + 1
        self.tileGoal = self.player.x + TILESIZE
    elseif self.player.direction == 'down'
    and not self.player.maze:isWall(self.player.mazeRow + 1, self.player.mazeCol) then
        self.animation.frames = {7, 8}
        self.player.mazeRow = self.player.mazeRow + 1
        self.tileGoal = self.player.y + TILESIZE
    else
        -- Change back to idle state if the selected tile is a wall
        gSounds['blip']:stop()
        gSounds['blip']:play()
        self.player:changeState('idle')
    end
end


function MoveState:update(dt)
    local tileReached = false
    self.player.currentAnimation:update(dt)

    -- Update player's coords based on current player's direction
    -- Then check if the agent reached the tile
    if self.player.direction == 'left' then
        self.player.x = self.player.x - WALK_SPEED * dt
        if self.player.x < self.tileGoal then
            self.player.x = self.tileGoal
            tileReached = true
        end
    elseif self.player.direction == 'up' then
        self.player.y = self.player.y - WALK_SPEED * dt
        if self.player.y < self.tileGoal then
            self.player.y = self.tileGoal
            tileReached = true
        end
    elseif self.player.direction == 'right' then
        self.player.x = self.player.x + WALK_SPEED * dt
        if self.player.x > self.tileGoal then
            self.player.x = self.tileGoal
            tileReached = true
        end
    elseif self.player.direction == 'down' then
        self.player.y = self.player.y + WALK_SPEED * dt
        if self.player.y > self.tileGoal then
            self.player.y = self.tileGoal
            tileReached = true
        end
    end
    -- Change to idle if the agent reached the destination
    if tileReached then
        self.player.maze:enterMove(self.prevRow, self.prevCol)
        self.player:changeState('idle')
    end
end