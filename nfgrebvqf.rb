#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'chingu'
include Gosu

puts "*** configuring baby seals"

require 'level'

# NOTE trait/state ideas
# - a vector.. or discrete physics trait?
#   * velocity/acceleration for angle
#   * propel/repel other objects velocity/acceleration
#   * helpers for angle_to.. objects/mouse/center
# - confirmation popup state
# - in game ruby debug console
# NOTE game features
# - bullet repeat / charge beam
# - other weapons.. laser (ray through multiple items), seeking missiles
# - energy? (some kind of trade off for firing/shields)
# - accuracy
# - game states
# - high scores
# - lives
# - charge beam
# - other weapon drops, with limited ammo

# this is a bug in chingu, i shouldnt need it.

class Game < Chingu::Window
  def setup
    transitional_game_state(Chingu::GameStates::FadeTo, :speed => 5)
    push_game_state(Level)
  end
end

Game.new.show
