class GameScene

  def initialize(window)
    @map = Map.new(window, './assets/map.yml')
    @player = Character.new(window, './assets/sprite.png')
  end

  def update(direction)
    @player.update(direction, @map)
  end

  def draw(window)
    @player.draw(window.width / 2 / 16, window.height / 2 / 16)
    @map.draw(@player.x + 1, @player.y + 1)
  end
end
