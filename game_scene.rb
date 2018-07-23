class GameScene < Scene

  LEFT = Gosu::Button::KbLeft
  UP = Gosu::Button::KbUp
  DOWN = Gosu::Button::KbDown
  RIGHT = Gosu::Button::KbRight

  ENTER = Gosu::KbEnter

  def initialize(window)
    @map = Map.new(window, './assets/map.yml')
    @player = Character.new(window, './assets/sprite.png')
    @state_manager = StateManager.new
    @state_manager.add_state(:game_menu, GameMenuState.new(window, @state_manager, :main))
    @state_manager.add_state(:main, State.new(window))
    @state_manager.add_state(:moving, MovingState.new(window, @player, @map, @state_manager))

    @state_manager.set_state(:main)
  end

  def update(window)
    direction = ''
    direction = :left if window.button_down? LEFT
    direction = :right if window.button_down? RIGHT
    direction = :up if window.button_down? UP
    direction = :down if window.button_down? DOWN

    if @state_manager.current_state == @state_manager.find(:main) && !direction.empty?
      @state_manager.set_state(:moving)
    end

    @state_manager.current_state.update(window, direction)
  end

  def draw(window)
    @state_manager.current_state.draw(window)
    @player.draw(window.width, window.height)
    @map.draw(@player.x + 2, @player.y + 2)
  end

  def button_down(window, id)
    @state_manager.current_state.button_down(window, id)
  end

  def button_up(window, id)
    if @state_manager.current_state == @state_manager.find(:main)
      @state_manager.set_state(:game_menu) if id == ENTER
    else
      @state_manager.current_state.button_up(window, id)
    end
  end
end
