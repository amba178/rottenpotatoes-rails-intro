class Movie < ActiveRecord::Base
	
	def self.all_ratings
		%w(PG G PG-13 R)
	end
end
