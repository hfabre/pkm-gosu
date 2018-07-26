class Map

  attr_reader :width, :height

  ZORDER = 1

  def initialize(window, map_file)
    @window_height = window.height
    @window_width = window.width
    load(window, map_file)
  end

  def draw(center_width, center_height)
    board = viewable_board(center_width, center_height)
    board.each_with_index do |line, y|
      line.each_with_index do |tile, x|
        @tileset[@tiles[tile].position].draw(x * @tile_size, y * @tile_size, ZORDER)
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

  def viewable_board(pos_x, pos_y)
    board = []

    offset_x = @window_width / @tile_size / 2
    offset_y = @window_height / @tile_size / 2

    line_range = ((pos_x - offset_x)..(pos_x + offset_x)).to_a
    column_range = ((pos_y - offset_y)..(pos_y + offset_y)).to_a

    column_range.each do |y|
      line = []
      line_range.each do |x|
        line << get_tile(x, y)
      end
      board << line
    end

    board
  end

  # def viewable_board(x, y)
  #   y_range = (y.to_i - @sliced_view_size)..(y.to_i + @sliced_view_size)
  #   x_range = (x.to_i - @sliced_view_size)..(x.to_i + @sliced_view_size)
  #
  #   board = []
  #
  #   y_range.to_a.each do |j|
  #     line = []
  #
  #     x_range.to_a.each do |i|
  #       tile = get_tile(j, i)
  #       line << tile
  #     end
  #
  #     board << line
  #   end
  #
  #   board
  # end

  def load(window, map_file)
    infos = Psych.load_file(map_file)['infos']

    @tile_size = infos['tile_size']
    @height = infos['map'].length
    @width = infos['map'].first.length
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
