class ScoreList < Fidgit::GuiState
  def initialize
    super

    on_input :esc, :close

    vertical align: :center do
      label "nfgrebvqf scores:"

      scores = Chingu::HighScoreList.load size: 10

      scores.each do |high_score|
        label "#{high_score[:name]} #{high_score[:score]}"
      end

      button "Back", align_h: :center, tip: "Quit" do
        close 
      end
    end
  end
end
