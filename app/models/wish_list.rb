class WishList
  include Mongoid::Document

  field :game_references, type: Array, default: []
  belongs_to :user

  def games
  	return [] if self.game_references.empty?
  	self.game_references.map{|g| Game.find(g) }
  end

  def update_list(game)
  	if game_references.include?(game.id)
  	  game_references.delete(game.id); self.save
  	  return false
  	else
  	  game_references << game.id; self.save 
  	  return true 
  	end
  end
end