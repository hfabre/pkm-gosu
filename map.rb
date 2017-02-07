class Map
  require 'psych'

  attr_reader :width, :height

  ZORDER = 1

  def initialize(window, map_file)
    load(window, map_file)
  end

  def draw(cam_pos_x, cam_pos_y)
    frame_board = viewable_board(cam_pos_y, cam_pos_x)
    frame_board.each_with_index do |line, j|
      line.each_with_index do |tile, i|
        @tileset[@tiles[tile].position].draw(j * @tile_size, i * @tile_size, ZORDER)
      end
    end
  end

  def blocked?(tile_y, tile_x)
    tile = @board[tile_y][tile_x]
    return true unless tile
    @tiles[tile].collidable?
  end

  def wrapper?(tile_y, tile_x)
    tile = @board[tile_y][tile_x]
    return false unless tile
    @tiles[tile].wrapper?
  end

  def get_wrapper_position(tile_y, tile_x)
    tile = @board[tile_y][tile_x]
    return nil unless tile
    @tiles[tile].wrapper_position
  end

  private

  def viewable_board(x, y)
    y_range = (y.to_i - @sliced_view_size)..(y.to_i + @sliced_view_size)
    x_range = (x.to_i - @sliced_view_size)..(x.to_i + @sliced_view_size)

    board = []

    y_range.to_a.each do |j|
      line = []

      x_range.to_a.each do |i|
        tile = get_tile(j, i)
        line << tile
      end

      board << line
    end

    board
  end

  def load(window, map_file)
    infos = Psych.load_file(map_file)['infos']

    @tile_size = infos['tile_size']
    @height = infos['map'].length
    @width = infos['map'].first.length
    @sliced_view_size = (@height / 2).floor
    @tileset = Gosu::Image.load_tiles(window, infos['tileset'], @tile_size, @tile_size, false)

    @tiles = []
    infos['tiles'].each do |k, v|
      @tiles << Tile.new(k.to_s, v.delete('tile'), v)
    end
    @out_of_limit_tile = infos['out_of_limit_tile']


    @board = infos['map']
  end

  def get_tile(x, y)
    if out_of_width_limits?(x) || out_of_height_limits?(y)
      @out_of_limit_tile
    else
      @board[y][x]
    end
  end

  def out_of_width_limits?(x)
    x > @width - 1 || x < 0
  end

  def out_of_height_limits?(x)
    x > @height - 1 || x < 0
  end
end