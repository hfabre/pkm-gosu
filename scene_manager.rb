require 'singleton'

class SceneManager
  include Singleton

  attr_reader :current_scene

  def initialize
    @scenes = {}
    @current_scene = nil
  end

  def add_scene(scene_name, scene)
    @scenes[scene_name] = scene
  end

  def set_scene(scene_name)
    @current_scene.unload if @current_scene.respond_to? :unload
    @current_scene = @scenes[scene_name]
    @current_scene.load if @current_scene.respond_to? :load
  end
end