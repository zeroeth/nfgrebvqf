require 'chingu'

class AsteroidBig < Chingu::GameObject
  traits :bounding_circle, :collision_detection
  traits :velocity, :screen_warp, :vector
  # score trait (give and receive)

  attr_accessor :score
  attr_accessor :rotation_speed

  def initialize(options={})
    super({:x => rand($window.width), :y => rand($window.width), :angle => rand(360), :image => Gosu::Image["asteroid_big.png"]}.merge(options))
    self.velocity = vector(rand)
    self.rotation_speed = rand * 2
    self.zorder = 3
    self.score = 100
  end

  def update
    super
    self.angle += rotation_speed
  end

  def destroy
    super

    Gosu::Sound["explode.wav"].play
  end
end

class AsteroidSmall < AsteroidBig
  def initialize(options={})
    super({:image => Gosu::Image["asteroid_small.png"]}.merge(options))
    self.score = 50
  end
end

class AsteroidTiny < AsteroidBig
  def initialize(options={})
    super({:image => Gosu::Image["asteroid_tiny.png"]}.merge(options))
    self.score = 10
  end
end
