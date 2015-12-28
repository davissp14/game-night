
class BoardGameScrape
  BASE_URL = 'http://www.boardgamegeek.com/geeksearch.php?action=search&objecttype=boardgame&q='

  attr_accessor :games, :title, :name, :thumbnail, :game_id, :url

  def initialize(title)
  	@agent = Mechanize.new
  	@title = title
  	self.games ||= []
  	scrape
  end

  def scrape
  	page = @agent.get(BASE_URL + self.title.downcase)
  	page.search("tr#row_").each do |row|
  	  game = Game.find_or_initialize_by(game_id: game_id(row))
  	  game.update_attributes(title: name(row), url: url(row), thumbnail: thumbnail(row), rating: rating(row))
  	
	  self.games << game
  	end
  end

  def name(html)
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
  end

  def rating(html)
	html.search('td.collection_bggrating').children[0].text.to_f.round(2)
  end

  def game_id(html)
  	url(html).split('/')[2]
  end

end

