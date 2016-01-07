class SearchRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  field :query, type: String
  field :last_request, type: Date

  index({query: 1})

  def self.current(query)
  	self.where(query: query).first
  end

  def recent?
  	!self.last_request || self.last_request > 1.month.ago
  end

end