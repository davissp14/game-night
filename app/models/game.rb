class Game < ActiveRecord::Base
  include ActiveRecord::Validations
  
  validates :game_id, uniqueness: true


  def scrape?
  	!self.last_scraped || self.last_scraped < 1.week.ago
  end
end