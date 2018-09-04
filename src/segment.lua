segment = diplodocus.thing()

function segment.mt:init( ... )
	for k,v in pairs(self.options) do
		self[k] = v
	end
end

function segment.mt:update()
end
function segment.mt:draw()
	love.graphics.printf(self.message,0,love.graphics.getHeight()/2,love.graphics.getWidth(),"center")
end