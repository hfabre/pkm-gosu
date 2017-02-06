require 'gosu'

require_relative './character'
require_relative './map'
require_relative './tile'

class GameWindow < Gosu::Window

  LEFT = Gosu::Button::KbLeft
  UP = Gosu::Button::KbUp
  DOWN = Gosu::Button::KbDown
  RIGHT = Gosu::Button::KbRight

  ESC = Gosu::Button::KbEscape

  def initialize
    super 360, 360
    self.caption = "Test"

    @map = Map.new(self, './assets/map.yml')
    @player = Character.new(self, './assets/sprite.png')
  end

  def update
    self.close if button_down? ESC
    direction = ''
    direction = :left if button_down? LEFT
    direction = :right if button_down? RIGHT
    direction = :up if button_down? UP
    direction = :down if button_down? DOWN

    @player.update(direction, @map)
  end

  def draw
    @player.draw(self.width / 2 / 16, self.height / 2 / 16)
    @map.draw(@player.x + 1, @player.y + 1)
  end
end

GameWindow.new.show