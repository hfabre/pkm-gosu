class Tile
  attr_reader :position, :name

  def initialize(tile_name, tile_pos, options={})
    @name = tile_name
    @position = tile_pos
    load_options(options)
  end

  def collidable?
    @collidable
  end

  def wrapper?
    @wrapper
  end

  def wrapper_position
    [@x, @y]
  end

  private

  def load_options(options)
    @collidable = true if options.delete('collide')
    if wrapper = options.delete('wrapper')
      @wrapper = true
      @x = wrapper.delete('x')
      @y = wrapper.delete('y')
      raise 'Invalid map: wrapper should have x and y attributes' unless @x || @y
    end
  end
end