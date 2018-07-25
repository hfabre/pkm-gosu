class MovingState < State
  SPEED = 0.2
  STEP = 1

  def initialize(window, player, map, state_manager)
    @player = player
    @map = map
    @state_manager = state_manager
    @step = 0
    @direction = ''
    super(window)
  end

  def update(window, direction)
    if @step >= 16
      @step = 0
      if @map.wrapper?(@player.y, @player.x)
        x, y = map.get_wrapper_position(@y, @x)
        @player.update(@direction, x, y)
      end
      @direction = ''
      @state_manager.set_state(:main)
    elsif @step == 0
      @direction = direction

      unless direction.empty?
        blocked = case direction
                  when :left
                    @map.blocked?(@player.y, @player.x - STEP)
                  when :right
                    @map.blocked?(@player.y, @player.x + STEP)
                  when :up
                    @map.blocked?(@player.y - STEP, @player.x)
                  when :down
                    @map.blocked?(@player.y + STEP, @player.x)
                  end
      end

      unless blocked
        @step += STEP
        x, y = new_player_position(@direction)
        @player.update(@direction, x, y)
      end
    else
      @step += STEP
      x, y = new_player_position(@direction)
      @player.update(@direction, x, y)
    end
  end

  private

  def new_player_position(direction)
    x = @player.x
    y = @player.y

    unless direction.empty?
      case direction
      when :left
        x -= SPEED
      when :right
        x += SPEED
      when :up
        y -= SPEED
      when :down
        y += SPEED
      end
    end

    [x, y]
  end
end
