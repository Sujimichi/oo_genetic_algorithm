#Adds .sum functionality to Arrays
module SimpleArrayMaths
	def sum
		sum = 0
		self.each {|n| sum += n}
		sum
	end
end
