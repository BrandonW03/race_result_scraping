class Race
	attr_accessor :name, :date, :distance, :time, :link
	
	def initialize(name, date, distance, time, link)
		@name = name
		@date = date
		@distance = distance
		@time = time
		@link = link
	end
end
