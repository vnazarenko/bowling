class GamesController < ApplicationController
  before_filter :find_game, only: [:show, :update]

  def new
    @game = Game.new
  end

  def create
    game = BowlingLogic.create_new_game
    begin
      params[:players].each do |name|
        next if name.blank?
        player = User.create!(name: name)
        BowlingLogic.add_player_to(player, game)
      end
      BowlingLogic.start_game!(game)
      redirect_to action: :show, id: game.id

    rescue  => ex
      game.destroy
      flash[:error] = "You can't start game without players"
      redirect_to action: :new
    end
  end

  def show
    @scoreboard = BowlingLogic.game_scoreboard(@game)
  end

  def update
    begin
      score = params[:score]
      score = rand(11 - @game.current_frame.first_try_score.to_i) if params[:score].blank?
      BowlingLogic.take_score(@game,  score)
      redirect_to action: :show, id: @game.id
    rescue  => ex
      flash[:error] = ex.message
      redirect_to action: :show, id: @game.id
    end
  end

  private
  def find_game
    @game = Game.find(params[:id])
    redirect_to :root unless @game
  end
end
