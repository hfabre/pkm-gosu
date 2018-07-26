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
    if @step >= 5
      @step = 0
      if @map.wrapper?(@player.y, @player.x)
        x, y = @map.get_wrapper_position(@player.y, @player.x)
        @player.update(@direction, x.to_i, y.to_i)
      end
      @direction = ''
      @state_manager.set_state(:main)
    elsif @step == 0
      @direction = direction

      unless direction.empty?
        p "Current positions: #{@player.x} - #{@player.y}"
        blocked = case direction
                  when :left
                    p "Checking in #{@player.x - STEP} - #{@player.y}"
                    @map.blocked?(@player.y, @player.x - STEP)
                  when :right
                    p "Checking in #{@player.x + STEP} - #{@player.y}"
                    @map.blocked?(@player.y, @player.x + STEP)
                  when :up
                    p "Checking in #{@player.x} - #{@player.y - STEP}"
                    @map.blocked?(@player.y - STEP, @player.x)
                  when :down
                    p "Checking in #{@player.x} - #{@player.y + STEP}"
                    @map.blocked?(@player.y + STEP, @player.x)
                  end

        if blocked
          @player.update_animation(direction)
        else
          @step += STEP
          x, y = new_player_position(@direction)
          @player.update(@direction, x, y)
        end
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
