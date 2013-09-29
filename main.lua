-- Look for modules in lib/ directory
package.path = "./lib/?.lua;" .. package.path

local basicgame = require('hug.basicgame')
local menustate = require('states.menustate')

function love.run()
  local running = true
  
  local now  = love.timer.getMicroTime()
  local last = now
  
  local acc  = 0
  
  local PHYS_HZ   = 60
  local PHYS_RATE = 1 / PHYS_HZ
  
  while running do
    now  = love.timer.getMicroTime()
    acc  = acc + now - last
    last = now
    
    if love.event then
      love.event.pump()
      for e,a,b,c,d in love.event.poll() do
        if e == "quit" then
          if not love.quit or not love.quit() then
            if love.audio then
              love.audio.stop()
            end
            running = false
          end
        end
        love.handlers[e](a,b,c,d)
      end
    end
    
    while acc >= PHYS_RATE do
      love.update(PHYS_RATE)
      acc = acc - PHYS_RATE
    end
    
    love.graphics.clear()
    love.draw(acc / PHYS_RATE)
    love.graphics.present()
  end
end

basicgame.start(menustate.new())