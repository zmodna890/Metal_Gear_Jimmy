Dialogue = Class{__includes = BaseState}

function Dialogue:init()
    -- Start transition alpha at full, and fade in (gradually to 0)
    self.transitionAlpha = 1

    -- Create a maze at (X, Y)
    self.maze = Maze(352, 72)
    
    -- How much of the dialogue to show
    self.showDialogue = 0
    self.dialogueDuration = 5
    self.text = "You have been entrusted with a special mission: guiding\nDr. Jimmy Vasko (also known by his enemies as The Ph.D.),\na CIA agent with unique CS135 abilities, through a maze.\nYour task is to provide instructions to the agent who has\nbeen airdropped to the maze's starting point, ensuring he\nreaches the destination swiftly, as time is of the essence."
    self.printedText = ""
    
    -- Pause input while dialogue is displaying
    self.pauseInput = true
    self.currentMenuItem = 1
end


function Dialogue:enter()
    -- Change music
    gSounds['music']:stop()
    gSounds['sneaking']:play()

    -- Transition in
    gSounds['codecopen']:play()
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    -- After 1 second, pause for 0.5 seconds, then play the dialogue for x duration
    :finish(function()
        Timer.after(0.5, function()
            -- Play dialogue sfx
            gSounds['dialogue']:play()
            Timer.tween(self.dialogueDuration, {
                [self] = {showDialogue = #self.text}
            })
            :finish(function()
                -- Allow input after showing all dialogue
                self.pauseInput = false
            end)
        end)
    end)
end


function Dialogue:update(dt)
    -- Quit button
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    -- Update dialogue to be shown
    self.printedText = string.sub(self.text, 0, math.ceil(self.showDialogue))

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
            if self.currentMenuItem == 2 then
                -- Change dialogue then quit
                self.text = "\n\nERROR: Terminating mission...\n...Hasta la bye bye agent Jimmy!"
                self.printedText = ""
                self.showDialogue = 0

                gSounds['dialogue']:play()
                Timer.tween(self.dialogueDuration, {
                    [self] = {showDialogue = #self.text}
                })
                :finish(function ()
                    gSounds['codecover']:play()
                    Timer.tween(2, {
                        [self] = {transitionAlpha = 1}
                    })
                    :finish(function ()
                        love.event.quit()
                    end)
                end)
            else
                -- Transition to Play state
                gSounds['codecover']:play()
                Timer.tween(1, {
                    [self] = {transitionAlpha = 1}
                })
                :finish(function()
                    gStateMachine:change('play', {
                        ['maze'] = self.maze
                    })
                end)
            end

            -- Turn off input during transition phase
            self.pauseInput = true
        end
    end

    Timer.update(dt)
end


function Dialogue:render()
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
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end


-- Helper function for rendering options
function Dialogue:drawOptions()
    -- Darken the surroundings
    love.graphics.setColor(0, 0, 0, 130/255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_WIDTH)
    
    love.graphics.setFont(gFonts['large'])
    if self.currentMenuItem == 1 then
        -- Highlight box
        love.graphics.setColor(84/255, 163/255, 118/255, 1)
        love.graphics.rectangle('fill', 424, 240, 438, 72)
        -- Highlight color
        love.graphics.setColor(209/255, 1, 118/255, 1)
    else
        love.graphics.setColor(139/255, 169/255, 23/255, 1) -- Normal text
    end
    love.graphics.printf("ACCEPT MISSION", 228, 260, 868, 'center')

    if self.currentMenuItem == 2 then
        -- Highlight box
        love.graphics.setColor(84/255, 163/255, 118/255, 1)
        love.graphics.rectangle('fill', 424, 312, 438, 72)
        -- Highlight color
        love.graphics.setColor(209/255, 1, 118/255, 1)
    else
        love.graphics.setColor(139/255, 169/255, 23/255, 1) -- Normal text
    end
    love.graphics.printf("DECLINE MISSION", 228, 332, 868, 'center')
end