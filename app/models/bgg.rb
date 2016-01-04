
class BGG
  BASE_URL = 'http://www.boardgamegeek.com/geeksearch.php?action=search&objecttype=boardgame&q='

  class << self 

    def scrape(title)
    	page = Mechanize.new.get(BASE_URL + title.downcase)
    	page.search("tr#row_").map do |row|
    	  game = Game.find_or_initialize_by(game_id: game_id(row))
    	  if game.scrape?
          game.update_attributes(
            title: title(row), 
            url: url(row), 
            thumbnail: thumbnail(row), 
            rating: rating(row)
          )
        end
        BGGExtended.scrape(game)
    	end
    end

    def title(html)
      html.search(".collection_objectname a").last.children.text
    end

    def url(html)
       html.search(".collection_objectname a").last.attributes['href'].value
    end

    def thumbnail(html)
  	  path = html.search("td.collection_thumbnail img").first['src']
      arr = path.split('/')
      arr[-1] = path.split('/').last.gsub('mt', 't')
      arr.join('/')
    rescue 
      "//cf.geekdo-images.com/images/pic1657689_t.jpg"
    end

    def rating(html)
  	  html.search('td.collection_bggrating').children[0].text.to_f.round(2)
    end

    def game_id(html)
    	url(html).split('/')[2]
    end

  end

end

