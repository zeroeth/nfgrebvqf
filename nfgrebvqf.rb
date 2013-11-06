#!/usr/bin/env ruby
$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "lib"))

require 'rubygems'
require 'bundler/setup'
require 'chingu'
require 'fidgit'
include Gosu

puts "*** configuring baby seals"

require 'level'
require 'menu'
require 'score_list'

# this is a bug in chingu, i shouldnt need it.

class Game < Chingu::Window
  def setup
    push_game_state Menu
  end

  def start_game
    push_game_state Level
  end

  def show_scores
    push_game_state ScoreList
  end

end

Game.new.show
