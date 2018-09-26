local state = {}
local orange = {243,157,20}
local sits = {}
lastgame = {}
doSkip = false
local current = 1
local timeToNext = 0

function drawCentered(thing, xo, yo, sm, r)
	local sc = love.graphics.getWidth()/thing:getWidth()
	sc = sc*(sm or 1)
	love.graphics.draw(
		thing,
		love.graphics.getWidth()/2 + (xo or 0),
		love.graphics.getHeight()/2 + (yo or 0),
		r or 0,sc,sc,
		thing:getWidth()/2,
		thing:getHeight()/2
	)
end

function drawBottom(thing, xo, yo, sm, r)
	local sc = love.graphics.getWidth()/thing:getWidth()
	sc = sc*(sm or 1)
	love.graphics.draw(
		thing,
		love.graphics.getWidth()/2 + (xo or 0),
		love.graphics.getHeight() - (yo or 0),
		r or 0,sc,sc,
		thing:getWidth()/2,
		thing:getHeight()
	)
end


function state:init()
	table.insert(sits,segment.new({
		logo = love.graphics.newImage("images/logo_plastic_arcade.png"),
		skip = -1,
		func = function()
			--exec(1)
		end,
		butt = function( ... )
			print("beep")
			doSkip = true
		end,
		update = function(self, dt)
			insertcoin:update(dt)
		end,
		draw = function(self)
			love.graphics.setColor(orange)
			drawCentered(self.logo, 0, 0, 0.45)
			insertcoin:draw()
		end
	}))
	table.insert(sits,segment.new({
		skip = 3,
		image = love.graphics.newImage("images/ARTWORKPLASTIROID.jpg"),
		func = function()
			exec(1)
		end,
		butt = function( ... )
		end
	}))
	table.insert(sits,segment.new({
		skip = 3,
		image = love.graphics.newImage("images/ARTWORKPLASTICBEACH.jpg"),
		func = function()
			exec(2)
		end,
		butt = function( ... )
		end
	}))
	table.insert(sits,segment.new({
		skip = 3,
		image = love.graphics.newImage("images/ARTWORKCALLOFDUTRI.jpg"),
		func = function()
			exec(3)
		end,
		butt = function( ... )
		end
	}))
	level = 1
	table.insert(sits,segment.new({
		logo = love.graphics.newImage("images/logo_plastic_arcade.png"),
		thanks = love.graphics.newImage("images/thanks_for_playing.png"),
		created = love.graphics.newImage("images/created.png"),
		score = love.graphics.newImage("images/score.png"),
		continue = love.graphics.newImage("images/do_you_want_to_continue.png"),
		skip = 10,
		func = function()
			gstate.switch(menu)
		end,
		enter = function()
			lastgame = {
				json.decode(love.filesystem.read("saves/plastiroid.json")),
				json.decode(love.filesystem.read("saves/plasticbeach.json")),
				json.decode(love.filesystem.read("saves/callofdutri.json"))
			}
			level = 1
		end,
		butt = function( ... )
			doSkip = true
			gstate.switch(menu)
		end,
		update = function(self, dt)
			local score = 0
			local max = 0
			for i,v in ipairs(lastgame) do
				score = score + v.updoots
				max = max + v.updoots + v.downdoots
			end

			level = useful.lerp(level,score/max,dt*3)
			insertcoin:update(dt)
		end,
		draw = function(self)
			insertcoin:draw()
			love.graphics.setColor(orange)
			love.graphics.rectangle("fill",love.graphics.getWidth()/2-600,love.graphics.getHeight()/2+100,1200,10)
			love.graphics.setColor(255,255,255)
			drawCentered(self.thanks, 0, -330, 0.2)
			drawCentered(self.created, 0, -50, 0.3)
			drawCentered(self.score, 0, 50, 0.3)
			love.graphics.rectangle("fill",love.graphics.getWidth()/2-600,love.graphics.getHeight()/2+100,1200*math.max(0,math.min(1,level)),10)
			love.graphics.setColor(orange)
			drawCentered(self.logo, 0, -200, 0.3)
			drawBottom(self.continue, 0, 250, 0.3)
		end
	}))
end

insertcoin = {
	arrow = love.graphics.newImage("images/arrow.png"),
	text = love.graphics.newImage("images/insert_plastic.png"),
	arrowheight = 0,
	arrowvel = 0,
	arrowphase = "falling",
	textheight = 0,
	textvel = 0,
	textphase = "falling",
	update = function(self, dt)
			if self.arrowphase=="falling" then
				self.arrowvel=self.arrowvel-dt*300
				self.arrowheight=self.arrowheight+self.arrowvel*dt
				if self.arrowheight<=0 then
					self.arrowheight=-self.arrowheight
					self.arrowvel = -self.arrowvel*0.4
					if math.abs(self.arrowvel)<5 then
						self.arrowphase = "raising"
					end
				end
			else
				self.arrowvel=0
				self.arrowheight = useful.lerp(self.arrowheight,55,dt*5)
				if self.arrowheight>25 then
					self.textphase = "raising"
				end
				if self.arrowheight>50 then
					self.arrowphase = "falling"
				end
			end
			if self.textphase=="falling" then
				self.textvel=self.textvel-dt*300
				self.textheight=self.textheight+self.textvel*dt
				if self.textheight<=0 then
					self.textheight=-self.textheight
					self.textvel = -self.textvel*0.4
				end
			else
				self.textvel=0
				self.textheight = useful.lerp(self.textheight,55,dt*5)
				if self.textheight>50 then
					self.textphase = "falling"
				end
			end
		end,
		draw = function(self)
			love.graphics.setColor(255,255,255)
			drawBottom(self.arrow, 0, 30+self.arrowheight, 0.1)
			drawBottom(self.text, 0, 160+self.textheight, 0.2)
		end
}

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
		if (sits[current].enter) then
			sits[current]:enter()
		end
		timeToNext = sits[current].skip
	end
end


function state:draw()
	love.graphics.scale(scalo)
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