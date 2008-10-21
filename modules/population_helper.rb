#Module for extending the Population class 
#adds member selection to the population
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
