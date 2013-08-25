local tilemap = require('game.tilemap')
local imageslicer = require('game.imageslicer')
local path = require('game.path')
local portal = require('game.portal')

local level = {}
local mt = {__index = level}

function level.new(name)
  local filename = 'data/levels/' .. name
  
  if love.filesystem.exists(filename) == false then
    error("level " .. name .. " doesn't exist!")
  end
  
  local chunk = love.filesystem.load(filename)
  local data = chunk()
  
  local instance = setmetatable({}, mt)
  instance:process(data)
  instance:validate()
  
  return instance
end

function level:process(data)
  if data.orientation ~= 'orthogonal' then
    error('invalid map orientation')
  end
  
  self.width  = data.width
  self.height = data.height
  self.tilewidth  = data.tilewidth
  self.tileheight = data.tileheight
  
  self.portals = {}
  
  for i = 1, #data.tilesets do
    self:processTileset(data.tilesets[i])
  end
  
  for i = 1, #data.layers do
    self:processLayer(data.layers[i])
  end
end

function level:processTileset(tileset)
  if tileset.name == 'main' then
    self.image = love.graphics.newImage(path.resolve('data/levels/' .. tileset.image))
    self.quads = imageslicer.createQuads(tileset.imagewidth, tileset.imageheight, tileset.tilewidth, tileset.tileheight)
  end
end

function level:processLayer(layer)
  if layer.type == 'tilelayer' and layer.name == 'foreground' then
    self.foreground = tilemap.new(layer.data, layer.width, layer.height)
  elseif layer.type == 'objectgroup' and layer.name == 'objects' then
    self:processObjects(layer.objects)
  end
end

function level:processObjects(objects)
  for i = 1, #objects do
    local object = objects[i]
    if object.type == 'playerspawn' then
      self.playerspawn = object
    elseif object.type == 'portal' then
      self.portals[#self.portals + 1] = portal.new(object.x, object.y, object.properties.destination)
    end
  end
end

function level:validate()
  assert(self.foreground,  'foreground layer not defined')
  assert(self.playerspawn, 'playerspawn object not defined')
  assert(self.image,       'image not loaded')
  assert(self.quads,       'quads not defined')
end

function level:solidAt(x, y)
  -- convert x and y from pixel to tile coordinates
  local tx = math.floor(x / self.tilewidth) + 1
  local ty = math.floor(y / self.tileheight) + 1
  
  if tx <= 0 then return false, 0, 0 end
  if ty <= 0 then return false, 0, 0 end
  
  local layer = self.foreground
  return self.foreground:at(tx, ty) ~= 0, tx * self.tilewidth, (ty - 1) * self.tileheight
end

function level:draw(camera)
  -- only draw what we can see
  -- this assumes that the love transform has been translated by the camera's position
  local minx, maxx, miny, maxy
  minx = math.max(0,           math.floor(-camera.x / 32))
  maxx = math.min(self.width,  math.ceil((-camera.x + camera.w) / 32))
  miny = math.max(0,           math.floor(-camera.y / 32))
  maxy = math.min(self.height, math.ceil((-camera.y + camera.h) / 32))
  
  love.graphics.setColor(255, 255, 255)
  for y = miny, maxy do
    for x = minx, maxx - 1 do
      local tid = self.foreground:at(x+1, y)
      if tid > 0 then
        love.graphics.drawq(self.image, self.quads[tid], (x) * 32, (y-1) * 32)
      end
    end
  end
  
  -- TODO: Replace with some sort of portal graphic?
  love.graphics.setColor(0, 0, 180)
  for i = 1, #self.portals do
    love.graphics.rectangle('fill', self.portals[i].x, self.portals[i].y, 64, 96)
  end
end

return level