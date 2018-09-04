local state = {}

local sits = {}

doSkip = false
local current = 1
local timeToNext = 0
function state:init()
	table.insert(sits,segment.new({
		image = love.graphics.newImage("images/Box_Present_HD.png"),
		skip = -1,
		message = "Press any button to play",
		func = function()
			exec(1)
		end,
		butt = function( ... )
			print("beep")
			doSkip = true
		end,
		draw = function(self)
			local sc = love.graphics.getWidth()/self.image:getWidth()
			sc = math.min(sc,love.graphics.getHeight()/self.image:getHeight())
			sc = sc * 1-((math.sin(love.timer.getTime()))/2+0.5)*0.01
			love.graphics.draw(self.image,
				love.graphics.getWidth()/2,
				love.graphics.getHeight()/2,
				math.cos(love.timer.getTime()*0.873)*0.02,
				sc,sc,
				self.image:getWidth()/2,
				self.image:getHeight()/2
				)
		end
	}))
	table.insert(sits,segment.new({
		skip = 3,
		message = "Wow! Cool stuff!",
		func = function()
			exec(2)
		end,
		butt = function( ... )
		end
	}))
	table.insert(sits,segment.new({
		skip = 3,
		message = "Impressive!",
		func = function()
			exec(3)
		end,
		butt = function( ... )
		end
	}))
	table.insert(sits,segment.new({
		skip = 10,
		message = "Thanks for doing us a play!",
		func = function()
			gstate.switch(menu)
		end,
		butt = function( ... )
			doSkip = true
			gstate.switch(menu)
		end
	}))
end


function state:enter( pre )
	current = 1
	timeToNext = 1
end


function state:leave( next )
end


function state:update(dt)
	timeToNext = timeToNext-math.min(1/30,dt)
	sits[current]:update(dt)
	if doSkip or (sits[current].skip>0 and timeToNext<0) then
		current = current+1
		doSkip = false
		sits[current-1]:func()
		timeToNext = sits[current].skip
	end
end


function state:draw()
	sits[current]:draw()
end


function state:errhand(msg)
end


function state:focus(f)
end


function state:keypressed(key, isRepeat)
	if key=='escape' then
		love.event.push('quit')
	end
	sits[current]:butt(key)
end


function state:keyreleased(key, isRepeat)
end


function state:mousefocus(f)
end


function state:mousepressed(x, y, btn)
end


function state:mousereleased(x, y, btn)
end


function state:quit()
end


function state:resize(w, h)
end


function state:textinput( t )
end


function state:threaderror(thread, errorstr)
end


function state:visible(v)
end


function state:gamepadaxis(joystick, axis)
end


function state:gamepadpressed(joystick, btn)
end


function state:gamepadreleased(joystick, btn)
end


function state:joystickadded(joystick)
end


function state:joystickaxis(joystick, axis, value)
end


function state:joystickhat(joystick, hat, direction)
end


function state:joystickpressed(joystick, button)
end


function state:joystickreleased(joystick, button)
end


function state:joystickremoved(joystick)
end

return state