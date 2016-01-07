class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  field :game_id, type: String
  field :url, type: String
  field :thumbnail, type: String
  field :rating, type: String
  field :title, type: String
  field :description, type: String
  field :playtime, type: String 
  field :year_published, type: String
  field :subdomain, type: String
  field :num_players, type: String
  field :min_age, type: String
  field :last_scraped, type: Date

  has_and_belongs_to_many :categories, class_name: "Category"
  
  validates :game_id, uniqueness: true

  index({game_id: 1}, {unique: true})

  
  def scrape?
  	!self.last_scraped || self.last_scraped < 10.years.ago
  end
end