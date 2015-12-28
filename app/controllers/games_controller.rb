class GamesController < ApplicationController
  
  def index
  	if params[:game_title]
  	  @games = BoardGameScrape.new(params[:game_title]).games
  	else
  	  @games = BoardGameScrape.new('Pandemic').games
  	end
  end

end
