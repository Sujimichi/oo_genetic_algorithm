#A Population is defined in this algorithm as a collection of Individuals
#The population is responsible for managing the individuals.

class Population 
  include PopulationHelper

  def initialize config = nil
    @config = config if config
    @config ||= Configs.new.binary_basic
    new_population
  end

  def new_population
    @population = []
    @config[:population_size].times do |i|
      @population[i] = Individual.new(@config)
    end
    @population
  end

  def get_pop
    @population
  end

  def print
    puts_pop self
  end

  def over_write_pop= pop
    @population = pop if pop.class == Population
  end

  def replace_individual old, new
    @population[@population.index(old)] = new if new.class == Individual
  end

  def get_mates
    i = self.random_member
    j = self.random_member
    while i == j
      j = self.random_member
    end
    return [ i, j ]
  end

  def generation
    @generation
  end
  alias gen generation

end
