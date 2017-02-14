require 'gosu'
require 'singleton'
require 'psych'

require_relative './character'
require_relative './map'
require_relative './tile'
require_relative './scene'
require_relative './scene_manager'
require_relative './game_scene'

class GameWindow < Gosu::Window

  ESC = Gosu::Button::KbEscape

  def initialize
    super 360, 360
    self.caption = "Test"

    game_scene = GameScene.new(self)
    SceneManager.instance.add_scene(:game_scene, game_scene)
    SceneManager.instance.set_scene(:game_scene)
  end

  def update
    self.close if button_down? ESC

    SceneManager.instance.current_scene.update(self)
  end

  def draw
    SceneManager.instance.current_scene.draw(self)
  end

  def button_down(id)
    SceneManager.instance.current_scene.button_down(id)
  end

  def button_up(id)
    SceneManager.instance.current_scene.button_down(id)
  end
end

GameWindow.new.show