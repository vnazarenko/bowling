class WellcomeController < ApplicationController

  def index
    @current_games = Game.in_progress
    @finished_games = Game.finished
  end
end
