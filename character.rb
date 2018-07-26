class Character
  attr_reader :x, :y

  SPRITE_SIZE = 16
  FRAME_DELAY = 120
  ANIMATION_NB = 4
  ZORDER = 2
  SPEED = 0.2

  def initialize(window, sprite_path)
    @sprite = load_sprite_from_image(window, sprite_path)
    @facing = :down
    @image_count = 0
    @y = window.height / 2 / SPRITE_SIZE
    @x = window.width / 2 / SPRITE_SIZE
  end

  def update(direction, x, y)
    @x = x
    @y = y
    update_animation(direction)
  end

  def update_animation(direction)
    unless direction.empty?
      @facing = direction
      if frame_expired?
        @image_count += 1
        @image_count = 0 if done?
      end
    end
  end

  def reset_animation!
    @image_count = 0
  end

  def draw(pos_x, pos_y)
    return if done?
    # Middle of game window
    @sprite[@facing][@image_count].draw((pos_x / 2) - (SPRITE_SIZE / 2), (pos_y / 2) - (SPRITE_SIZE / 2), ZORDER)
  end

  def done?
    @image_count == ANIMATION_NB
  end

  private

  def frame_expired?
    now = Gosu.milliseconds
    @last_frame ||= now

    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
    else
      false
    end
  end

  def load_sprite_from_image(window, sprite_path)
    sprites = Gosu::Image.load_tiles(window, sprite_path, SPRITE_SIZE, SPRITE_SIZE, false)
    { left: sprites[4..7], right: sprites[12..15], down: sprites[0..3], up: sprites[8..11] }
  end
end
