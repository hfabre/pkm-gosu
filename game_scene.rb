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

    @state_manager.set_state(:main)
  end

  def update(window)
    direction = ''
    direction = :left if window.button_down? LEFT
    direction = :right if window.button_down? RIGHT
    direction = :up if window.button_down? UP
    direction = :down if window.button_down? DOWN

    @player.update(direction, @map) if @state_manager.current_state == @state_manager.find(:main)
    @state_manager.current_state.update(window)
  end

  def draw(window)
    @state_manager.current_state.draw(window)
    @player.draw(window.width, window.height)
    @map.draw(@player.x + 1, @player.y + 1)
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
