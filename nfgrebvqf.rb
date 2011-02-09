#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'chingu'

puts "*** configuring baby seals"

require 'player_ship'
require 'bullet'
require 'asteroids'

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
    @player = PlayerShip.create
    @player.input = {:holding_left => :turn_left, :holding_right => :turn_right, :space => :fire, :up => :engines_on, :holding_up => :engines_thrusting, :released_up => :engines_off}
    10.times{ AsteroidBig.create }
  end

  def update
    super

    Bullet.each_collision(AsteroidBig, AsteroidSmall) do |bullet, asteroid|
      bullet.destroy
      asteroid.destroy

      Gosu::Sound["explode.wav"].play

      if asteroid.instance_of? AsteroidBig
	2.times{ AsteroidSmall.create :x => asteroid.x, :y => asteroid.y }
      end
    end
  end
end

Game.new.show
