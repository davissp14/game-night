class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  validates_uniqueness_of :name

  field :name, type: String

  def games
  	Game.where(category_ids: self).to_a
  end

end
