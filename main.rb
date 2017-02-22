require 'gosu'
require 'singleton'
require 'psych'

require_relative './character'
require_relative './map'
require_relative './tile'
require_relative './scene'
require_relative './menu'
require_relative './state'
require_relative './state_manager'
require_relative './menu_item'
require_relative './scene_manager'
require_relative './game_scene'
require_relative './game_menu_state'

class GameWindow < Gosu::Window

  ESC = Gosu::Button::KbEscape

  ZORDER_FONT = 6

  def initialize
    super 360, 360
    self.caption = "Test"

    @font = Gosu::Font.new(self, Gosu.default_font_name, 20)

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
    puts "#{id} downed"
    SceneManager.instance.current_scene.button_down(self, id)
  end

  def button_up(id)
    puts "#{id} uped"
    SceneManager.instance.current_scene.button_up(self, id)
  end

  def write(x, y, str, options={})
    font = options.delete(:font) || @font
    font.draw(str, x, y, ZORDER_FONT, 1.0, 1.0, Gosu::Color::BLACK)
  end
end

GameWindow.new.show