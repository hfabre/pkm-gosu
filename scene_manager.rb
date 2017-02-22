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
    p "Setting scene: #{scene_name}"
    @current_scene&.unload
    @current_scene = @scenes[scene_name]
    @current_scene&.load
  end

  def find(scene_name)
    @scenes[scene_name]
  end
end