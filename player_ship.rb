require 'chingu'
require 'game_traits'
require 'bullet'

class PlayerShip < Chingu::GameObject
  traits :bounding_circle
  traits :velocity, :screen_warp, :vector

  attr_accessor :engine_glow

  def initialize(options={})
    super options.merge(:x => $window.width/2, :y => $window.height/2, :image => Gosu::Image["ship.png"])
    self.zorder = 2
    self.input = {:holding_left => :turn_left, :holding_right => :turn_right, :space => :fire, :up => :engines_on, :holding_up => :engines_thrusting, :released_up => :engines_off}
  end

  def turn_left
    self.angle -= 2
  end

  def turn_right
    self.angle += 2
  end

  def fire
    Bullet.create :angle => angle, :x => x, :y => y, :velocity => bullet_velocity
    Gosu::Sound["blaster.wav"].play
  end

  def bullet_velocity
    # TODO get length of current velocity vector
    return vector(3 + velocity_x.abs)
  end

  def engines_on
    self.engine_glow = Gosu::Sound["engine.wav"].play(1,1,true) if engine_glow.nil? || !engine_glow.playing?
  end

  def engines_thrusting
    # TODO use a delta from fps
    self.acceleration = vector(0.1)
  end

  def engines_off
    engine_glow.stop
    self.acceleration = 0,0
  end
end
