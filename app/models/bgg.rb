
class BGG
  BASE_URL = 'http://www.boardgamegeek.com/geeksearch.php?action=search&objecttype=boardgame&q='
  BROWSE_URL = 'http://boardgamegeek.com/browse/boardgame'


  class << self 

    def controlled_scrape(page=1)
      puts "Scraping page #{page}"
      if page == 1
        html = Mechanize.new.get(BROWSE_URL+"?sort=rank&sortdir=asc")
      else
        html = Mechanize.new.get(BROWSE_URL + "/page/#{page}?sort=rank&sortdir=asc")
      end

      html.search("tr#row_").each do |row|
        id = game_id(row)
        if id 
          game = Game.find_or_initialize_by(game_id: id)
          if game.new_record?
            puts "Scraping id: #{id}"
            game.update_attributes(
              title: title(row), 
              url: url(row), 
              thumbnail: thumbnail(row), 
              rating: rating(row)
            )
          else
            puts "Already scraped id: #{game.game_id}, title: #{game.title}"
          end
        else
          puts "ID NOT FOUND"
        end
      end
    end

    def scrape(title)

      # Don't re-scrape search if recently searched
      request = SearchRequest.where(query: title).first
      if request
        request.update_attributes(last_request: Date.today)
      else
        SearchRequest.create!(query: title, last_request: Date.today)
      end

      games = []
    	page = Mechanize.new.get(BASE_URL + title.downcase)
      page.search("tr#row_").each_with_index do |row, index| 
        id = game_id(row)
        game = Game.find_or_initialize_by(game_id: id)
        if game.scrape?
          game.update_attributes(
            title: title(row), 
            url: url(row), 
            thumbnail: thumbnail(row), 
            rating: rating(row)
          )
          Rails.logger.info("Id: #{id}, Game '#{title}' is being scraped .. extensivly.")
          games << BGGExtended.scrape(game)
        else
          Rails.logger.info("Id: #{id}, Game '#{title}' has already been scraped")
          games << game 
        end
        break if index > 14
      end

      games
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

