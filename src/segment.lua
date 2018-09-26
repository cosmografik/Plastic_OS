segment = diplodocus.thing()

function segment.mt:init( ... )
	for k,v in pairs(self.options) do
		self[k] = v
	end
end

function segment.mt:update()
end
function segment.mt:draw()
	love.graphics.setColor(self.color and self.color or {255,255,255})
	if self.image then
		local scale = 1
		scale = math.min(
			scale,
			love.graphics.getWidth()/self.image:getWidth()
		)
		scale = math.min(
			scale,
			love.graphics.getHeight()/self.image:getHeight()
		)
		love.graphics.draw(self.image,love.graphics.getWidth()/2,love.graphics.getHeight()/2,0,scale,scale,self.image:getWidth()/2,self.image:getHeight()/2)
	end
	if self.message then
		love.graphics.printf(self.message,0,love.graphics.getHeight()/2,love.graphics.getWidth(),"center")
	end
end