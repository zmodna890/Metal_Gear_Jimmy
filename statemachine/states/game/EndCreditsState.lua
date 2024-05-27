EndCreditsState = Class{__includes = BaseState}


function EndCreditsState:init()
    self.transitionAlpha = 1
    -- Start the end credits from the bottom of the screen
    self.scroll = VIRTUAL_HEIGHT
    -- Duration of the end credits (sec)
    self.duration = 15
end


function EndCreditsState:enter()
    gSounds['music']:play()

    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function ()
        Timer.tween(self.duration, {
            [self] = {scroll = 0}
        })
    end)
end


function EndCreditsState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Timer.update(dt)
end


function EndCreditsState:render()
    -- Render option to press ESC to exit the game
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    local width = gFonts['medium']:getWidth("PRESS ESC\nTO EXIT")
    love.graphics.print("PRESS ESC\nTO EXIT", (VIRTUAL_WIDTH - 15) - width, 15)

    -- Make the texts appear from the bottom
    self:renderCredits()

    -- Transition rectangle
    love.graphics.setColor(0, 0, 0, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end


function EndCreditsState:renderCredits()
    -- Translate coordinate system to the bottom of the screen
    love.graphics.translate(0, self.scroll)
    love.graphics.setFont(gFonts['dialogue'])
    love.graphics.printf("INSPIRED BY", 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("UNLV CS135 FALL 2023 ASSIGNMENT\nMADE BY DR. BEN CISNEROS-MERINO", 0, 125, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['dialogue'])
    love.graphics.printf("SPECIAL THANKS TO", 0, 289, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("COLTON OGDEN AND THE ENTIRE CS50 STAFF", 0, 314, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['dialogue'])
    love.graphics.printf("BASED ON", 0, 446, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("METAL GEAR SOLID BY KONAMI", 0, 471, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("*THIS GAME IS NOT AN ACCURATE REPRESENTATION OF METAL GEAR SOLID*", 0, 503, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("https://github.com/zmodna890/Metal_Gear_Jimmy", 0, 619, VIRTUAL_WIDTH, 'center')
end