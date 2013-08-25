local control = require('ui.control')
local panel = setmetatable({}, { __index = control })

function panel.new()
  local instance = control.new()
  instance.w = 400
  instance.h = 400
  instance.backcolor = { 100, 100, 100 }
  instance.bordercolor = { 140, 140, 140 }
  instance.borderwidth = 2
  instance.text = 'panel'
  
  return setmetatable(instance, { __index = panel })
end

function panel:draw()
  if not self.visible then
    return
  end
  
  local g = love.graphics
  g.setColor(self.backcolor)
  g.rectangle('fill', self.x, self.y, self.w, self.h)
  
  g.setFont(self.font)
  g.setColor(self.forecolor)
  g.print(self.text, self.x, self.y)
  
  g.setColor(self.bordercolor)
  g.setLineWidth(self.borderwidth)
  g.rectangle('line', self.x, self.y, self.w, self.h)
  g.line(self.x, self.y + self.font:getHeight(), self.x + self.w, self.y + self.font:getHeight())
  
  g.translate(self.x, self.y)
  for i = 1, #self.children do
    self.children[i]:draw()
  end
end

return panel