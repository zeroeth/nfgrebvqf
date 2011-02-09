require 'chingu'
require 'game_traits'

class Bullet < Chingu::GameObject
  traits :bounding_circle, :collision_detection
  traits :velocity, :screen_warp, :vector
  traits :timer

  def initialize(options={})
    super options.merge(:image => Gosu::Image["bullet.png"])
    after(5000) { self.destroy }  
  end
end

