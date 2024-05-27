Animation = Class{}

function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.timer = 0
    self.currentFrame = 1
end


function Animation:update(dt)
    -- No need to update if there is only 1 frame in the animation
    if #self.frames > 1 then
        -- Update timer by dt
        self.timer = self.timer + dt

        -- If enough time has passed the set interval, then
        if self.timer > self.interval then
            -- Reset the timer
            self.timer = self.timer % self.interval
            -- Update current frame to the next frame in the animation
            -- Next frame index % (Num of frames + 1)
            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))
        end
    end
end


function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end