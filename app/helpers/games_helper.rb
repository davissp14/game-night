module GamesHelper

	def pagination_count(page)
	  page = page.to_i
	  page = 1 if page == 0
	  min = (15 * page - 15)
	  min = 1 if min == 0
	  max = (page * 15) > @raw_games.size ? @raw_games.size : (page * 15)
	  "#{min} - #{max}"
	end

	def game_state(game)
	  collection = current_user.fetch_collection(game)

	  case collection
	  when "wish_list"
	  	"Wish list"
	  when "collection"
	  	"Collection"
	  else
	  	"Add to"
	  end
	end

	def wish_class(game)
	  return "btn btn-default btn-sm wish-list" unless current_user
	  if current_user.wish_list.games.include?(game)
	  	"btn btn-success btn-sm wish-list"
	  else
		"btn btn-default btn-sm wish-list"
	  end
	end

	def collection_class(game)
	  return "btn btn-default btn-sm collection" unless current_user
	  if current_user.collection.games.include?(game)
	  	"btn btn-success btn-sm collection"
	  else
		"btn btn-default btn-sm collection"
	  end
	end
end
