#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'chingu'
include Gosu

puts "*** configuring baby seals"

require 'level'

# this is a bug in chingu, i shouldnt need it.

class Game < Chingu::Window
  def setup
    transitional_game_state(Chingu::GameStates::FadeTo, :speed => 5)
    push_game_state(Level)
  end
end

Game.new.show
