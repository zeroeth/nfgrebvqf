class Menu < Fidgit::GuiState
  def initialize
    super

    on_input :esc, :exit

    vertical align: :center do
      image_frame Gosu::Image["ship.png"], align_h: :center
      label "nfgrebvqf", align_h: :center

      button "Play!", align_h: :center, tip: "Start" do
        start_game
      end

      button "High Score", align_h: :center, tip: "Start" do
        $window.show_scores
      end

      button "Quit", align_h: :center, tip: "Quit" do
        exit
      end
    end
  end

  def add name
    puts "WEEEE #{name}"
  end

  def start_game
    $window.start_game
  end
end
