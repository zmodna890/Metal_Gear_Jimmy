IdleState = Class{__includes = BaseState}

function IdleState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {},
        interval = 0.1
    }
    
    self.player.currentAnimation = self.animation
end


function IdleState:enter()
    if self.player.direction == 'left' then
        self.animation.frames = {4}
    elseif self.player.direction == 'up' then
        self.animation.frames = {1}
    elseif self.player.direction == 'right' then
        self.animation.frames = {3}
    elseif self.player.direction == 'down' then
        self.animation.frames = {2}
    end
end


function IdleState:update(dt)
    -- Check if space was pressed first
    if love.keyboard.wasPressed('q') then
        -- Change state to move state
        self.player:changeState('move')
    else
        -- Update direction and animation's table based on keypress
        if love.keyboard.wasPressed('a') then
            self.player.direction = 'left'
            self.animation.frames = {4}
        elseif love.keyboard.wasPressed('w') then
            self.player.direction = 'up'
            self.animation.frames = {1}
        elseif love.keyboard.wasPressed('d') then
            self.player.direction = 'right'
            self.animation.frames = {3}
        elseif love.keyboard.wasPressed('s') then
            self.player.direction = 'down'
            self.animation.frames = {2}
        end
        -- Update animation after changing directions
        self.player.currentAnimation:update(dt)
    end
end