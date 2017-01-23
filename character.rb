class Character
  SPRITE_SIZE = 16
  FRAME_DELAY = 60 # ms
  ANIMATION_NB = 4

  def initialize(window, sprite_path)
    @sprite = load_sprite_from_image(window, sprite_path)
    @facing = :down
    @image_count = 0
  end

  def update(direction)
    unless direction.empty?
      @facing = direction
      if frame_expired?
        @image_count += 1
        @image_count = 0 if done?
      end
    end
  end

  def draw(x, y)
    return if done?
    @sprite[@facing][$key_pressed ? @image_count : 0].draw(x, y, 1, 1, 1)
  end

  def done?
    @image_count == ANIMATION_NB
  end

  private

  def current_frame
    @sprite[@facing][@image_count % ANIMATION_NB]
  end

  def frame_expired?
   now = Gosu.milliseconds
   @last_frame ||= now
   if (now - @last_frame) > FRAME_DELAY
     @last_frame = now
   end
  end

  def load_sprite_from_image(window, sprite_path)
    sprites = Gosu::Image.load_tiles(window, sprite_path, SPRITE_SIZE, SPRITE_SIZE, false)
    {:left => sprites[4..7], :right => sprites[12..15],
      :down => sprites[0..3], :up => sprites[8..11]}
  end
end