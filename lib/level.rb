require 'chingu'
require 'score'
require 'player_ship'
require 'bullet'
require 'asteroids'
include Gosu

class Level < Chingu::GameState
  def initialize
    super
    self.input = {:esc => :exit, :p => :pause, :e => :edit, :d => :debug}

    @lives = 3
    @score = 0
    @score_text = Chingu::Text.create(:x => 1, :y => 1, :size => 20)

    load_game_objects
  end

  def edit
    push_game_state(Chingu::GameStates::Edit)
  end

  def debug
    push_game_state(Chingu::GameStates::Debug)
  end

  def pause
    push_game_state(Chingu::GameStates::Pause)
  end

  def update
    super

    PlayerShip.each_collision(AsteroidBig, AsteroidSmall, AsteroidTiny) do |player, asteroid|
      player.destroy
      @lives -= 1

      if @lives > 0
	PlayerShip.create
      else
	# TODO this might happen conccurently? 3 collisions in 1 frame?
	push_game_state(Chingu::GameStates::Pause)
      end

    end

    Bullet.each_collision(AsteroidBig, AsteroidSmall, AsteroidTiny) do |bullet, asteroid|
      bullet.destroy
      asteroid.destroy

      @score += asteroid.score

      # TODO spawn_at helper
      if asteroid.instance_of? AsteroidBig
	(rand(2)+1).times{ AsteroidSmall.create :x => asteroid.x, :y => asteroid.y }
	rand(2).times{ AsteroidTiny.create :x => asteroid.x, :y => asteroid.y}
      end

      if asteroid.instance_of? AsteroidSmall
	(rand(2)+1).times{ AsteroidTiny.create :x => asteroid.x, :y => asteroid.y}
      end
    end

    @score_text.text = @score
  end
end
