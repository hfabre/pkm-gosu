class Tile
  attr_reader :position, :name

  def initialize(tile_name, tile_pos, collidable)
    @name = tile_name
    @position = tile_pos
    @collidable = collidable
  end

  def collidable?
    @collidable
  end
end