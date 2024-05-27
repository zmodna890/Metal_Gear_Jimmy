MenuState = Class{__includes = BaseState}

function MenuState:init()
    -- Currently selected menu item
    self.currentMenuItem = 1

    -- Used for transition
    self.transitionAlpha = 0

    -- Pause selection while in transition
    self.pauseInput = false
end


function MenuState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- Don't change currently selected option
    -- during transition phase
    if not self.pauseInput then
        -- Change selected option
        if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('s') then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            gSounds['select']:play()
        end

        -- Enter another state based on the selected option
        if love.keyboard.wasPressed('q') then
            -- Play sound
            gSounds['enter']:play()
            -- EXIT OPTION
            if self.currentMenuItem == 1 then
                love.event.quit()
            else
                -- Within 1 second duration, change transition alpha
                -- to 1, then calls the finish function,
                -- which changes state to Dialogue
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                }):finish(function()
                    gStateMachine:change('dialogue')
                end)
            end

            -- Turn off input during transition phase
            self.pauseInput = true
        end
    end


    Timer.update(dt)
end


function MenuState:render()
    -- Render background and title
    self:drawBackgroundTitle()
    -- Render options
    self:drawOptions()

    -- Draw the transition rect; fully transparent until we move to the next state
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end


function MenuState:drawBackgroundTitle()
    love.graphics.draw(gTextures['background'], 0, 0)

    love.graphics.setFont(gFonts['large'])
    self:drawTextShadow("J  I  M  M  Y", 495, 161)
    love.graphics.setColor(136/255, 85/255, 56/255, 1)
    love.graphics.print("J  I  M  M  Y", 495, 161)
 
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow("Rated B for boring.", 535, 200)
    love.graphics.setColor(206/255, 181/255, 151/255, 1)
    love.graphics.printf("Rated B for boring.", 0, 200, VIRTUAL_WIDTH, 'center')
end


function MenuState:drawOptions()
    love.graphics.setFont(gFonts['large'])

    -- Draw text shadows
    self:drawTextShadow("EXIT", 425, 480)
    self:drawTextShadow("NEW GAME", 425, 530)
    -- Change the highlighted text based on the current menu item
    if self.currentMenuItem == 1 then
        love.graphics.setColor(1, 0, 0, 1)
    else
        love.graphics.setColor(130/255, 0, 0, 1)
    end
    love.graphics.print("EXIT", 425, 480)

    if self.currentMenuItem == 2 then
        love.graphics.setColor(1, 0, 0, 1)
    else
        love.graphics.setColor(130/255, 0, 0, 1)
    end
    love.graphics.print("NEW GAME", 425, 530)

    -- Movement guide text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow("MOVEMENT GUIDE: W (up), S (down), Q (select)", 420, 580)
    love.graphics.setColor(210/255, 191/255, 177/255, 1)
    love.graphics.print("MOVEMENT GUIDE: W (up), S (down), Q (select)", 420, 580)
end


function MenuState:drawTextShadow(text, x, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.print(text, x + 2, y + 1)
    love.graphics.print(text, x + 1, y + 1)
    love.graphics.print(text, x, y + 1)
    love.graphics.print(text, x + 1, y + 2)
end