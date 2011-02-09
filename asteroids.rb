require 'chingu'

class AsteroidBig < Chingu::GameObject
  traits :bounding_circle, :collision_detection
  traits :velocity, :screen_warp, :vector

  attr_accessor :rotation_speed

  def initialize(options={})
    super({:x => rand($window.width), :y => rand($window.width), :angle => rand(360), :image => Gosu::Image["asteroid_big.png"]}.merge(options))
    self.velocity = vector(rand)
    self.rotation_speed = rand * 2
  end

  def update
    super
    self.angle += rotation_speed
  end
end

class AsteroidSmall < AsteroidBig
  def initialize(options={})
    super({:image => Gosu::Image["asteroid_small.png"]}.merge(options))
  end
end
