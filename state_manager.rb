class StateManager
  attr_reader :current_state

  def initialize
    @states = {}
    @current_state = nil
  end

  def add_state(state_name, state)
    @states[state_name] = state
  end

  def set_state(state_name)
    p "Setting state: #{state_name}"
    @current_state = @states[state_name]
  end

  def find(state_name)
    @states[state_name]
  end
end