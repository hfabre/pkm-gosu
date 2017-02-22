class Menu

  ZORDER = 4
  PREV = Gosu::KB_BACKSPACE
  ENTER = Gosu::KbEnter
  UP = Gosu::Button::KbUp
  DOWN = Gosu::Button::KbDown

  def initialize(window, x, y, state_manager, options={})
    @x = x
    @y = y
    @height = options.delete(:height) || window.height
    @width = options.delete(:width) || window.width
    @state_manager = state_manager
    @items = []
    @selected = 0

    add_item(MenuItem.new(240, 20, 'save'))
    add_item(MenuItem.new(240, 40, 'quit'))
  end

  def add_item(item)
    @items << item
  end

  def draw(window)
    window.draw_quad(@x, @y, Gosu::Color::WHITE,
                     @x, @y + @height, Gosu::Color::WHITE,
                     @x + @width, @y, Gosu::Color::WHITE,
                     @x + @width, @y + @height, Gosu::Color::WHITE, ZORDER)
    @items.each_with_index do |item, i|
      if @selected == i
        window.write(item.x - 10, item.y, '>')
      end

      item.draw(window)
    end
  end

  def button_up(window, id)
    case id
    when ENTER
      @items[@selected].run(window)
    when PREV
      @state_manager.set_state(:main)
    when UP
      if @selected - 1 >= 0
        @selected -= 1
      end
    when DOWN
      if @selected + 1 < @items.size
        @selected += 1
      end
    end
  end
end