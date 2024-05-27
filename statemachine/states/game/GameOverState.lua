GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.transitionAlpha = 1
    self.pauseInput = true

    -- Dialogue
    self.showDialogue = 0
    self.dialogueDuration = 5
    self.text = "\nWhat's wrong!?...\nJimmy...\nJimmmyyyyyyy..."
    self.printedText = ""

    self.victory = false
end


function GameOverState:enter(params)
    gSounds['sneaking']:stop()

    Timer.tween(0.5, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function ()
        if params then
            self.text = params.text
            gSounds['victory']:play()
        else
            gSounds['game-over']:play()
        end
        -- 0.5 secs pause then show dialogue
        Timer.after(0.5, function ()
            gSounds['dialogue']:play()
            Timer.tween(self.dialogueDuration, {
                [self] = {showDialogue = #self.text}
            })
            :finish(function()
                -- Display end credits or options after 2 sec pause
                Timer.after(2, function ()
                    if params then
                        gSounds['codecover']:play()
                        Timer.tween(2, {
                            [self] = {transitionAlpha = 1}
                        })
                        :finish(function ()
                            gStateMachine:change("end-credits")
                        end)
                    else
                        self.pauseInput = false
                    end              
                end)
            end)
        end)
    end)
end


function GameOverState:update(dt)
    -- Update dialogue to be shown
    self.printedText = string.sub(self.text, 0, math.ceil(self.showDialogue))

    if not self.pauseInput then
        -- Return to menu
        if love.keyboard.wasPressed('r') then
            gSounds['music']:play()
            gStateMachine:change('menu')
        end
        -- Exit
        if love.keyboard.wasPressed('escape') then
            love.event.quit()
        end
    end

    Timer.update(dt)
end


function GameOverState:render()
    -- Render background
    love.graphics.draw(gTextures['dialogue'], 0, 0, 0, 2, 1.5)
    love.graphics.setColor(0, 10/255, 12/255, 1)
    love.graphics.rectangle('fill', 49 * 2, 254 * 1.5, 545 * 2, 145 * 1.5)

    -- Render dialogue
    if self.printedText then
        love.graphics.setColor(148/255, 148/255, 148/255, 1)
        love.graphics.setFont(gFonts['dialogue'])
        love.graphics.print(self.printedText, 79 * 2, 272 * 1.5)
    end

    -- Render options (after dialogue)
    if not self.pauseInput then
        self:drawOptions() 
    end

    -- Transition rectangle
    love.graphics.setColor(0, 0, 0, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end


-- Helper function for rendering options
function GameOverState:drawOptions()
    love.graphics.setFont(gFonts['dialogue'])
    love.graphics.setColor(148/255, 148/255, 148/255, 1)
    
    love.graphics.print("PRESS R TO RETURN TO START MENU\nPRESS ESC TO EXIT", 100, 625)
end