class BGG
  class GameNotFound < StandardError; end

  class << self 

    def find(title)
  	  game_data = base_game_data(title.downcase)
  	  if game_data.is_a?(Hash)
  	  	extended_game_data(game_data['objectid'], game_data['name'])
  	  else
  	  	game_data.map{|data| extended_game_data(data['objectid'], data['name'])}
  	  end
    end

    def base_game_data(title)
	  boardgames = fetch_data_from("http://www.boardgamegeek.com/xmlapi/search?search=#{title}")
	  raise GameNotFound if boardgames.blank?
	  boardgames
    end

    def extended_game_data(game_id, name)
  	  boardgame = fetch_data_from("http://www.boardgamegeek.com/xmlapi/boardgame/#{game_id}")
  	  {
  	  	object_id:      game_id,
  	  	name:           name,
  	    description:    boardgame['description'],
  	    min_players:    boardgame['minplayers'],
  	    max_players:    boardgame['maxplayers'],
  	    year_published: boardgame['yearpublished'],
  	    playtime:       boardgame['playingtime'],
  	    thumbnail:      boardgame['thumbnail'],
  	    image:          boardgame['image'],
  	    publisher:      boardgame['boardgamepublisher']
  	  }
    end

    def fetch_data_from(url)
	  xml_content = Net::HTTP.get(URI.parse(url))
	  data = Hash.from_xml(xml_content)
	  data['boardgames']['boardgame']
    rescue 
  	  nil 
    end

  end 
end
