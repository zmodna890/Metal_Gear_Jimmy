-- Libraries
push = require 'lib/push'
Class = require 'lib/class'
Timer = require 'lib/knife.timer'

-- Utils
require 'src/const'
require 'statemachine/StateMachine'
require 'statemachine/states/BaseState'
require 'src/Util'

-- Game Pieces
require 'src/Maze'
require 'src/Tile'

-- Game States
require 'statemachine/states/game/MenuState'
require 'statemachine/states/game/Dialogue'
require 'statemachine/states/game/PlayState'
require 'statemachine/states/game/GameOverState'
require 'statemachine/states/game/EndCreditsState'

-- Player States
require 'statemachine/states/player/Player'
-- Player Animations
require 'src/Animation'
require 'statemachine/states/player/IdleState'
require 'statemachine/states/player/MoveState'


-- Globals
gStateMachine = StateMachine {
    ['menu'] = function() return MenuState() end,
    ['dialogue'] = function() return Dialogue() end,
    ['play'] = function() return PlayState() end,
    ['game-over'] = function() return GameOverState() end,
    ['end-credits'] = function() return EndCreditsState() end
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/main.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['sneaking'] = love.audio.newSource('sounds/sneaking.mp3', 'static'),
    ['dialogue'] = love.audio.newSource('sounds/dialogue.mp3', 'static'),
    ['codecopen'] = love.audio.newSource('sounds/codecopen.wav', 'static'),
    ['codecover'] = love.audio.newSource('sounds/codecover.wav', 'static'),
    ['enter'] = love.audio.newSource('sounds/enter.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/gameover.mp3', 'static'),
    ['blip'] = love.audio.newSource('sounds/blip.mp3', 'static'),
    ['alert'] = love.audio.newSource('sounds/alert.mp3', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.mp3', 'static')
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/manaspc.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/manaspc.ttf', 16),
    ['dialogue'] = love.graphics.newFont('fonts/manaspc.ttf', 25),
    ['large'] = love.graphics.newFont('fonts/manaspc.ttf', 32)
}

gTextures = {
    ['background'] = love.graphics.newImage('images/background.jpg'),
    ['dialogue'] = love.graphics.newImage('images/dialogue.jpg'),
    ['agent'] = love.graphics.newImage('images/atlas.png'),
    [0] = love.graphics.newImage('images/tile.jpg'),
    [1] = love.graphics.newImage('images/box.jpg')
}

gFrames = {
    ['agent'] = GenerateQuads(gTextures['agent'])
}