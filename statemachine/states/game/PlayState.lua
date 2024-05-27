PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.transitionAlpha = 1
    self.pauseInput = true
end


function PlayState:enter(params)
    self.maze = params.maze
    -- Transition in
    gSounds['codecopen']:play()
    -- White box to transparent
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })

    -- Player object
    self.player = Player({
        stateMachine = StateMachine {
            ['idle'] = function() return IdleState(self.player) end,
            ['move'] = function() return MoveState(self.player) end
        },
        maze = self.maze
    })

    self.player:changeState('idle')
end


function PlayState:update(dt)
    -- Quit button
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- Update player
    self.player:update(dt)

    -- Check if current tile has a camera
    if self.player.maze:hasCamera(self.player.mazeRow, self.player.mazeCol) then
        Timer.tween(0.5, {
            [self] = {transitionAlpha = 1}
        })
        :finish(function ()
            gStateMachine:change('game-over')
        end)
    end

    -- Check if the player reached the goal
    if self.player:reachedGoal() then
        Timer.tween(0.5, {
            [self] = {transitionAlpha = 1}
        })
        :finish(function ()
            gStateMachine:change('game-over', {
                ['text'] = "\n\nGreat job avoiding the surveillance cameras, Agent Jimmy!\nNow is your chance to escape.",
                ['victory'] = true
            })
        end)
    end

    Timer.update(dt)
end


function PlayState:render()
    -- Maze
    -- Background color
    love.graphics.clear(1/255, 34/255, 23/255, 1)
    -- Draw maze
    self.maze:render()
    
    -- Draw the agent
    self.player:render()

    -- Transition rectangle
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT) 
end