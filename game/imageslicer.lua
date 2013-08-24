local imageslicer = {}

function imageslicer.createQuads(imagewidth, imageheight, tilewidth, tileheight)
  local quads = {}
  
  local nwide = imagewidth / tilewidth
  local nhigh = imageheight / tileheight
  
  for y = 0, nhigh - 1 do
    for x = 0, nwide - 1 do
      quads[#quads + 1] = love.graphics.newQuad(x * tilewidth, y * tilewidth, tilewidth, tileheight, imagewidth, imageheight)
    end
  end
  
  return quads
end

return imageslicer