require 'src/Dependencies'


function love.load()
   love.window.setTitle("Metal Gear Jimmy")

   math.randomseed(os.time())

   push:setupScreen(VIRTUAL_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      vsync = true,
      fullscreen = false,
      resizable = true,
      canvas = true
   })

   -- Adjust music
   gSounds['music']:setLooping(true)
   gSounds['sneaking']:setLooping(true)
   gSounds['music']:setVolume(0.25)
   gSounds['sneaking']:setVolume(0.25)
   -- Play music
   gSounds['music']:play()

   -- Initialize state machine
   gStateMachine:change('menu')

   love.keyboard.keysPressed = {}
end


function love.resize(w, h)
   push:resize(w, h)
end


function love.keypressed(key)
   love.keyboard.keysPressed[key] = true
end


function love.keyboard.wasPressed(key)
   if love.keyboard.keysPressed[key] then
      return true
   end

   return false
end


function love.update(dt)
   -- Update our current state
   gStateMachine:update(dt)

   love.keyboard.keysPressed = {}
end


function love.draw()
   push:start()
   -- Render our current state
   gStateMachine:render()
   push:finish()
end