class Map
  require 'psych'

  HEIGHT = 360
  WIDTH = 360

  ZORDER = 1

  def initialize(window, map_file)
    load(window, map_file)
  end

  def draw(cam_pos_x, cam_pos_y)
    frame_board = viewable_board(cam_pos_x, cam_pos_y)
    frame_board.each_with_index do |line, j|
      line.each_with_index do |tile, i|
        @tileset[tile.position].draw(i * @tile_size, j * @tile_size, ZORDER)
      end
    end
  end

  def blocked?(tile_y, tile_x)
    tile = @board[tile_y / @tile_size][tile_x / @tile_size]
    return true unless tile
    tile.collidable?
  end

  private

  def viewable_board(x, y)
    y_range = (y.to_i - @sliced_view_size)..(y.to_i + @sliced_view_size)
    x_range = (x.to_i - @sliced_view_size)..(x.to_i + @sliced_view_size)

    board = []

    y_range.to_a.each do |j|
      line = []

      x_range.to_a.each do |i|
        p j, i
        tile = get_tile(j, i)
        p tile
        line << tile
      end

      board << line
    end

    board
  end

  def load(window, map_file)
    infos = Psych.load_file(map_file)['infos']

    @tile_size = infos['tile_size']
    @height = infos['map'].length + 1
    @width = infos['map'].first.length + 1
    @sliced_view_size = (@height / 2).floor
    @tileset = Gosu::Image.load_tiles(window, infos['tileset'], @tile_size, @tile_size, false)

    @tiles = []
    infos['tiles'].each do |k, v|
      @tiles << Tile.new(k.to_s, v['tile'], v['collide'])
    end
    @out_of_limit_tile = @tiles[infos['out_of_limit_tile']]


    @board = infos['map'].map {|row| row.map {|tile| @tiles[tile]}}
  end

  def get_tile(x, y)
    if out_of_width_limits?(x) || out_of_height_limits?(y)
      @out_of_limit_tile
    else
      @board[y][x]
    end
  end

  def out_of_width_limits?(x)
    x > @width || x < 0
  end

  def out_of_height_limits?(x)
    x > @height || x < 0
  end
end