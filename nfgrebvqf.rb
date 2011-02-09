#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'chingu'

puts "*** configuring baby seals"

require 'player_ship'
require 'bullet'
require 'asteroids'

# NOTE
# - bullet repeat
# - energy?
# - accuracy
# - game states
# - high scores
# - lives
# - charge beam
# - other weapon drops, with limited ammo

class Game < Chingu::Window
  def initialize
    super
    self.input = {:esc => :exit}

    @player = PlayerShip.create
    10.times{ AsteroidBig.create }
  end

  def update
    super

    Bullet.each_collision(AsteroidBig, AsteroidSmall, AsteroidTiny) do |bullet, asteroid|
      bullet.destroy
      asteroid.destroy

      # TODO spawn_at helper
      if asteroid.instance_of? AsteroidBig
	(rand(2)+1).times{ AsteroidSmall.create :x => asteroid.x, :y => asteroid.y }
	rand(2).times{ AsteroidTiny.create :x => asteroid.x, :y => asteroid.y}
      end

      if asteroid.instance_of? AsteroidSmall
	(rand(2)+1).times{ AsteroidTiny.create :x => asteroid.x, :y => asteroid.y}
      end
    end
  end
end

Game.new.show
