scalo = 2
gw = love.graphics.getWidth
gh = love.graphics.getHeight
love.graphics.getWidth = function()
	return gw()/scalo
end
love.graphics.getHeight = function()
	return gh()/scalo
end

function love.load(arg)

	json = require("json")
	settings = json.decode(love.filesystem.read("settings.json"))

	diplodocus = require "diplodocus"

	useful = diplodocus.useful
	gstate = require "gamestate"
	gstate.registerEvents()
	require("segment")
	menu = require "menu"
	local test = require "test"

	if arg[2]=="test" then
		gstate.switch(test)
	else
		gstate.switch(menu)
	end
end

function exec(num)
	love.window.minimize()
	os.execute(settings.games[num].command)
	love.window.maximize()
end