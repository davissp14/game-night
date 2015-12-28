class Game < ActiveRecord::Base
  include ActiveRecord::Validations
  
  validates :game_id, uniqueness: true

end