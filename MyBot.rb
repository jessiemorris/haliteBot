$:.unshift(File.dirname(__FILE__))
require 'networking'

def calculateMove(location)
  Move.new(location, GameMap::DIRECTIONS.shuffle.first)
end


network = Networking.new("RubyBot")
tag, map = network.configure

while true
  moves = []
  map = network.frame

  (0...map.height).each do |y|
    (0...map.width).each do |x|
      loc = Location.new(x, y)
      site = map.site(loc)

      if site.owner == tag
        moves << calculateMove(loc) 
      end
    end
  end

  network.send_moves(moves)
end

