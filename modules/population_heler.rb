#Provides various mechanisms for member selection, 
#for use in the Population class
module PopulationHelper

	def random_member
		@population[(rand * @population.size).floor]
	end

	def random_pair
		i = self.random_member
		j = self.random_member
		while i == j
			j = self.random_member
		end
		[ i, j ]
	end

end
