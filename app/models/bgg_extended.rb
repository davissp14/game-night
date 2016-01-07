require 'htmlentities'

class BGGExtended
  BASE_URL = 'http://www.boardgamegeek.com'

  class << self 

    def scrape(game)
    	page = Mechanize.new.get(BASE_URL + game.url)
      game.update_attributes!(
        num_players: num_players(page),
        playtime: playtime(page), 
        year_published: year_published(page), 
        min_age: min_age(page),
        description: description(page),
        subdomain: subdomain(page),
        category_ids: categories(page),
        last_scraped: Time.now
      )
      puts "Done scraping #{game.title}"
  	  game.reload
    end

    def subdomain(html)
      html.links_with(href: /\/boardgamesubdomain.*/).first.text
    rescue
      nil
    end

    def categories(html)
      cs = html.links_with(href: /\/boardgamecategory\/\d+\/.*/).map(&:text)
      cs.map do |category|
        Category.where(name: category).first_or_create.id
      end
    end

    def num_players(html)
      html.search('div#edit_players').children[3].children.text.gsub(/\n\t*/, '')
    end

    def playtime(html)
      html.search('div#edit_playtime').children[3].children.text.gsub(/\n\t*/, '')
    end

    def year_published(html)
      html.search('div#edit_yearpublished').children[3].children.text.gsub(/\n\t*/, '')
    end

    def min_age(html)
      html.search('div#edit_minage').children[3].children.text.gsub(/\n\t*/, '')
    end 

    def description(html)
      HTMLEntities.new.decode(html.at('meta[name="twitter:description"]')['content'])
    end
  end

end

