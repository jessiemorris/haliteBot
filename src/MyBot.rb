$:.unshift(File.dirname(__FILE__))
require 'networking'

def getWeakestDirection(map,loc,site)
  north = map.site(loc, :north)
  east = map.site(loc, :east)
  south = map.site(loc, :south)
  west = map.site(loc, :west)
  neighbors = [north.strength, east.strength, south.strength, west.strength]
  
  if(neighbors.min == north.strength) then return :north end
  if(neighbors.min == east.strength)  then return :east end 
  if(neighbors.min == south.strength) then return :south end
  if(neighbors.min == west.strength)  then return :west end


  return GameMap::DIRECTIONS.shuffle.first
end

def nextMove()
  if(Random.rand() > 0.5) then return :north end
  return :east
end

def calculateMove(map,location,site)
  if(site.strength > site.production * 2)
    Move.new(location, nextMove())
  else
    #Dont move if you arent strong
    Move.new(location, :still)
  end

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
        moves << calculateMove(map, loc, site) 
      end
    end
  end

  network.send_moves(moves)
end

