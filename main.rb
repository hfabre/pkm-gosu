require 'gosu'

require_relative './character'
require_relative './map'
require_relative './tile'
require_relative './scene_manager'
require_relative './game_scene'

class GameWindow < Gosu::Window

  ESC = Gosu::Button::KbEscape
  LEFT = Gosu::Button::KbLeft
  UP = Gosu::Button::KbUp
  DOWN = Gosu::Button::KbDown
  RIGHT = Gosu::Button::KbRight

  def initialize
    super 360, 360
    self.caption = "Test"

    game_scene = GameScene.new(self)
    SceneManager.instance.add_scene(:game_scene, game_scene)
    SceneManager.instance.set_scene(:game_scene)
  end

  def update
    self.close if button_down? ESC

    direction = ''
    direction = :left if button_down? LEFT
    direction = :right if button_down? RIGHT
    direction = :up if button_down? UP
    direction = :down if button_down? DOWN

    SceneManager.instance.current_scene.update(direction)
  end

  def draw
    SceneManager.instance.current_scene.draw(self)
  end
end

GameWindow.new.show