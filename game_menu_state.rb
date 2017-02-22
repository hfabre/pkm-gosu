class GameMenuState < State

  def initialize(window, state_manager, previous_state)
    @menu = Menu.new(window, 230, 10, state_manager, height: 200, width: 100)
    @state_manager = state_manager
    @previous_state = previous_state
  end

  def draw(window)
    @menu.draw(window)
  end

  def button_up(window, id)
    @menu.button_up(window, id)
  end
end