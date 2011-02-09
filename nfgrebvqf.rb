#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'chingu'

puts "*** configuring baby seals"

# NOTE
# - bullet death timer
# - acceleration/decel
# - multiply thrust angles
# - game states
# - high scores
# - lives
# - charge beam
# - other weapon drops, with limited ammo

class Game < Chingu::Window
  def initialize
    super
    self.input = {:esc => :exit}

    # NOTE timer trait for fire spam?
    @player = Player.create
    @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :space => :fire, :up => :engines_on, :released_up => :engines_off}
    10.times{ AsteroidBig.create }
  end

  def update
    super

    # NOTE can this go in model?
    Bullet.each_collision(AsteroidBig, AsteroidSmall) do |bullet, asteroid|
      bullet.destroy
      asteroid.destroy

      if asteroid.instance_of? AsteroidBig
	2.times{ AsteroidSmall.create :x => asteroid.x, :y => asteroid.y }
      end
    end
  end
end

class Player < Chingu::GameObject
  trait :bounding_circle
  trait :velocity

  def initialize(options={})
    super options.merge(:x => $window.width/2, :y => $window.height/2, :image => Gosu::Image["ship.png"])
  end

  def turn_left
    self.angle -= 1.5
  end

  def turn_right
    self.angle += 1.5
  end

  def fire
    Bullet.create :angle => angle, :x => x, :y => y, :velocity => bullet_velocity
  end

  def bullet_velocity
    return vector(3 + velocity_x.abs)
  end

  def update
    super

    self.x = 0 if x > $window.width
    self.y = 0 if y > $window.height

    self.x = $window.width  if x < 0
    self.y = $window.height if y < 0

    #self.velocity_x *= 0.99
    #self.velocity_y *= 0.99
  end

  def vector(magnitude=1.0)
    ajusted_angle = angle - 90
    radians = ajusted_angle * Math::PI/180.0
    return Math::cos(radians)*magnitude, Math::sin(radians)*magnitude
  end
  def engines_on
    # TODO use a delta from fps
    #self.velocity = vector(2)
    self.acceleration = vector(0.1)
  end
  def engines_off
    self.acceleration = 0,0
  end
end

class Bullet < Chingu::GameObject
  trait :bounding_circle
  trait :velocity
  trait :collision_detection
  trait :timer

  def initialize(options={})
    super options.merge(:image => Gosu::Image["bullet.png"])
    after(10000) { self.destroy }  
  end
end

class AsteroidBig < Chingu::GameObject
  trait :bounding_circle
  trait :velocity
  trait :collision_detection

  attr_accessor :rotation_speed

  def initialize(options={})
    super({:x => rand($window.width), :y => rand($window.width), :angle => rand(360), :image => Gosu::Image["asteroid_big.png"]}.merge(options))
    set_velocity
    self.rotation_speed = rand * 2
  end

  def set_velocity
    ajusted_angle = angle - 90
    radians = ajusted_angle * Math::PI/180.0
    # TODO use a delta from fps
    speed = rand
    self.velocity = Math::cos(radians)*speed, Math::sin(radians)*speed
  end

  def update
    super
    
    self.x = 0 if x > $window.width
    self.y = 0 if y > $window.height

    self.x = $window.width  if x < 0
    self.y = $window.height if y < 0

    self.angle += rotation_speed
  end
end

class AsteroidSmall < AsteroidBig
  def initialize(options={})
    super({:image => Gosu::Image["asteroid_small.png"]}.merge(options))
  end
end

Game.new.show
