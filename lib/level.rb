require 'chingu'
require 'player_ship'
require 'bullet'
require 'asteroids'
include Gosu

class Level < Chingu::GameState
  def initialize
    super
    self.input = {:esc => :close, :p => :pause, :e => :edit, :d => :debug}

    puts "NEW LEVEL"
    @lives = 3
    @score = 0
    @info_text = Chingu::Text.create(:x => 1, :y => 1, :size => 20)

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
      Gosu::Sound["explode.wav"].play

      @lives -= 1

      if @lives > 0
        PlayerShip.create
      else
        PlayerShip.destroy_all
        AsteroidBig.destroy_all
        AsteroidSmall.destroy_all
        AsteroidTiny.destroy_all
        scores = Chingu::HighScoreList.load size: 10
        scores.add name: "player", score: @score
        close # NOTE pop state seems to cause problems
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

    @info_text.text = "Score: #{@score} Lives: #{@lives}"
  end
end
