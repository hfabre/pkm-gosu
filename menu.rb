class Menu

  def initialize(window, height=nil, width=nil)
    @height = height || window.height
    @width = width || window.width
    @items = []
    @selected = 0
  end

  def update(direction)

  end

  def draw(window)
    @items.each_with_index do |item, i|
      if @selected == i

      end
    end
  end
end