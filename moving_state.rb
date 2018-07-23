class MovingState < State

  def initialize(window, player, map, state_manager)
    @player = player
    @map = map
    @state_manager = state_manager
    @step = 0.0
    @direction == ''
    super(window)
  end

  def update(window, direction)
    p @step
    if @step >= 1.0
      @step = 0.0
      @state_manager.set_state(:main)
    elsif @step == 0.0
      @direction = direction
      @step += 0.2
      @player.update(@direction, @map)
    else
      @step += 0.2
      @player.update(@direction, @map)
    end
  end
end
