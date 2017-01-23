require 'gosu'

require_relative './character'

class GameWindow < Gosu::Window

  LEFT = Gosu::Button::KbLeft
  UP = Gosu::Button::KbUp
  DOWN = Gosu::Button::KbDown
  RIGHT = Gosu::Button::KbRight

  ESC = Gosu::Button::KbEscape

  def initialize
    super 640, 480
    self.caption = "Gosu article"

    @player = Character.new(self, './assets/sprite.png')
  end

  def update
    self.close if button_down? ESC
    direction = ''
    direction = :left if button_down? LEFT
    direction = :right if button_down? RIGHT
    direction = :up if button_down? UP
    direction = :down if button_down? DOWN
    $key_pressed = !direction.empty?
    @player.update(direction)
  end

  def draw
    @player.draw(50, 50)
  end
end

GameWindow.new.show