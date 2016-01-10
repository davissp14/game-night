class GamesController < ApplicationController


  def index
    if params[:game_title].present?
      @raw_games = Game.any_of(:title => /#{params[:game_title]}/i)
    elsif params[:wish_list].present?
      ids = current_user.wish_list.games.map(&:id)
      @raw_games = Game.where(id: {"$in" => ids})
    elsif params[:collection].present?
      ids = current_user.collection.games.map(&:id)
      @raw_games = Game.where(id: {"$in" => ids})
    else
      @raw_games = Game.all.desc('rating')
    end
     @games = @raw_games.paginate(:page => params[:page], per_page: 15)
  end

  def wish_list 
  	@game = Game.find(params[:game_id])
  	@response = current_user.wish_list.update_list(@game)

  rescue
  	render :js => "window.location = '/users/sign_in'"
  end

  def collection
  	@game = Game.find(params[:game_id])
  	@response = current_user.collection.update_list(@game)

  rescue
  	render :js => "window.location = '/users/sign_in'"
  end

end
