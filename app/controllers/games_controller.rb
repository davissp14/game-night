class GamesController < ApplicationController
  
  def index
    if params[:game_title]
      @games = BGG.scrape(params[:game_title])
    else
      @games = BGG.scrape('Pandemic')
    end
  end

end
