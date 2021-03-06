require 'chingu'
require 'game_traits'
require 'bullet'

class PlayerShip < Chingu::GameObject
  traits :bounding_circle, :collision_detection
  traits :velocity, :screen_warp, :vector
  traits :timer

  attr_accessor :engine_glow
  attr_accessor :rotation_speed
  attr_accessor :alive

  def initialize(options={})
    super options.merge(:x => $window.width/2, :y => $window.height/2)#, :image => Gosu::Image["ship.png"])
    self.image = Gosu::Image["ship.png"]
    self.zorder = 2
    self.input = {:holding_left => :turn_left, :holding_right => :turn_right, :space => :charge_weapon, :released_space => :fire, :holding_up => :engines_thrusting, :released_up => :engines_off}
    # FIXME still needs to be expressed as a delta
    self.rotation_speed = 3

    self.alive = true
  end

  def destroy
    engine_glow.stop if engine_glow
    super
  end


  def turn_left
    self.angle -= rotation_speed
  end

  def turn_right
    self.angle += rotation_speed
  end

  def charge_weapon
    # TODO max charge.. scale modifier or color?
    @charge = 1;
    every(100, :name => 'bullet_charge') { @charge += 0.1 }
  end

  def fire
    stop_timer('bullet_charge')
    Bullet.create :angle => angle, :scale => 1.0, :x => x, :y => y, :velocity => bullet_velocity(@charge)
    Gosu::Sound["blaster.wav"].play
  end

  def bullet_velocity(ratio = 1.0)
    # TODO move into vector trait
    bullet_x, bullet_y = vector(3*ratio) # wants to leave muzzle at velocity of 3
    ship_x, ship_y = velocity # ships current speed

    return (bullet_x + ship_x), (bullet_y + ship_y)
  end

  def engines_on
    self.engine_glow = Gosu::Sound["engine.wav"].play(1,1,true) if engine_glow.nil? || !engine_glow.playing?
  end

  def engines_thrusting
    engines_on
    # TODO use a delta from fps
    self.acceleration = vector(0.1)
  end

  def engines_off
    engine_glow.stop
    self.acceleration = 0,0
  end
end
