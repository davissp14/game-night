class GamesController < ApplicationController
  
  def index
    if params[:game_title].present?
      @raw_games = Game.any_of(:title => /#{params[:game_title]}/i)
      @games = @raw_games.paginate(:page => params[:page], per_page: 15)
    else
      @raw_games = Game.all.desc('rating')
      @games = @raw_games.paginate(:page => params[:page], per_page: 15)
    end
  end

end
