class GameState < State

  def initialize(player)
    @player = player
  end

  def update(window)
    direction = ''
    direction = :left if window.button_down? LEFT
    direction = :right if window.button_down? RIGHT
    direction = :up if window.button_down? UP
    direction = :down if window.button_down? DOWN

    @player.update(direction, @map)
  end
end