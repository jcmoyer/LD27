local tilemap = require('game.tilemap')
local imageslicer = require('game.imageslicer')
local path = require('game.path')

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
  
  return instance
end

function level:process(data)
  if data.orientation ~= 'orthogonal' then
    error('invalid map orientation')
  end
  
  self.width  = data.width
  self.height = data.height
  
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
  end
end

function level:solidAt(x, y)
  -- convert x and y from pixel to tile coordinates
  local tx = math.floor(x / 32) + 1
  local ty = math.floor(y / 32) + 1
  
  if tx <= 0 then return false, 0, 0 end
  if ty <= 0 then return false, 0, 0 end
  
  local layer = self.foreground
  return self.foreground:at(tx, ty) ~= 0, tx * 32, (ty - 1) * 32
end

return level