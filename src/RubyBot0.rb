$:.unshift(File.dirname(__FILE__))
require 'networking'
#test
def calculateMove(location,site)
  if(site.strength > 0)
    Move.new(location, GameMap::DIRECTIONS.shuffle.first)
  else
    #:still, cant figure out how to used named arrays
    Move.new(location, GameMap::DIRECTIONS[0])
  end

end



network = Networking.new("RubyBotv0")
tag, map = network.configure

while true
  moves = []
  map = network.frame

  (0...map.height).each do |y|
    (0...map.width).each do |x|
      loc = Location.new(x, y)
      site = map.site(loc)

      if site.owner == tag
        moves << calculateMove(loc, site) 
      end
    end
  end

  network.send_moves(moves)
end

