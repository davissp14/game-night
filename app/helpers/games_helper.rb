module GamesHelper

	def pagination_count(page)
	  page = page.to_i
	  page = 1 if page == 0
	  min = (15 * page - 15)
	  min = 1 if min == 0
	  max = page * 15
	  "#{min} - #{max}"
	end
end
